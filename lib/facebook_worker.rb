################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

puts '+++++++++++++++++++loading FacebookWorker++++++++++++++++'
class FacebookWorker
  class << self
    def retry_in; 30; end
    def max_attempts; 5; end

    def job_for(method, event_id)
      event = event_id.nil? ? nil : Event.find(event_id)
      attempt = 0

      begin
        session = Facebooker::Session.new(Facebooker.api_key, Facebooker.secret_key)

        yield event, session

        true
      rescue Facebooker::Session::UnknownError, Facebooker::Session::ServiceUnavailable,
          Facebooker::Session::MaxRequestsDepleted => e
        RAILS_DEFAULT_LOGGER.warn(
          "FacebookWorker has encountered exception on '#{method}' for event #{event.inspect}:\n" +
          e.to_s + "\nRetrying in #{retry_in} seconds (attempt #{attempt})...")
        sleep retry_in

        if attempt < max_attempts
          attempt += 1
          retry
        else
          RAILS_DEFAULT_LOGGER.error(
          "FacebookWorker has encountered exception on '#{method}' for event #{event.inspect}:\n" +
          e.to_s + "\nCancelling job (attempt #{attempt})...")
          false
        end
      rescue StandardError => e # Facebook errors extend these...
        RAILS_DEFAULT_LOGGER.error(
          "FacebookWorker has encountered exception on '#{method}' for event #{event.inspect}:\n" +
          e.to_s)
        false
      end
    rescue ActiveRecord::RecordNotFound
      RAILS_DEFAULT_LOGGER.warn(
        "FacebookWorker can't find Event with id #{event_id} for '#{method}'")
      false
    end

    def async_create(event_id)
      Bj.submit "ruby script/runner lib/facebook_worker.rb create #{event_id}"
    end

    def create(event_id)
      job_for(:create, event_id) do |event, session|
        facebook_id = session.post("events.create", {
          'event_info' => facebook_event_info(event).to_json
        })
        Event.update_all(
          ["facebook_id=?, facebook_title=?", facebook_id, event.title],
          ["id=?", event.id]
        )
      end
    end

    def async_edit(event_id)
      Bj.submit "ruby script/runner lib/facebook_worker.rb edit #{event_id}"
    end

    def edit(event_id)
      job_for(:edit, event_id) do |event, session|
        session.post("events.edit", {
          'eid' => event.facebook_id,
          'event_info' => facebook_event_info(event).to_json
        })
      end
    end

    def async_cancel(event_id, facebook_event_id)
      Bj.submit "ruby script/runner lib/facebook_worker.rb cancel #{event_id} " +
        "#{facebook_event_id}"
    end

    def cancel(event_id, facebook_event_id)
      event_id = event_id.to_i > 0 ? event_id : nil

      job_for(:cancel, event_id) do |event, session|
        session.post("events.cancel", {'eid' => facebook_event_id})
        Event.update_all(
          ["facebook_id=?, facebook_title=?", nil, nil],
          ["id=?", event.id]
        ) unless event.nil?
      end
    end

    protected
    def facebook_event_info(event)
      # Note: The start_time and end_time are the times that were input by the event creator,
      # converted to UTC after assuming that they were in Pacific time (Daylight Savings or
      # Standard, depending on the date of the event), then converted into Unix epoch time.
      # Basically this means for some reason facebook does not want to get epoch timestamps
      # here, but rather something like epoch timestamp minus 7 or 8 hours, depeding on the
      # date. have fun!
      #
      # http://wiki.developers.facebook.com/index.php/Events.create
      start_time = (event.start + 10.hours).to_i
      end_time = event.end ? (event.end + 10.hours).to_i : start_time

      {
        'name' => event.title,
        'category' => event.facebook_category.to_s,
        'subcategory' => event.facebook_subcategory.to_s,
        'location' => [event.place.title, event.place.classification].compact.join(', '),
        'street' => event.place.address,
        'city' => event.city.to_s,
        'description' => facebook_description(event),
        'privacy_type' => 'OPEN',
        'start_time' => start_time,
        'end_time' => end_time
      }
    end

    def facebook_description(event)
      text = ""

      uri = URI.parse(FACEBOOKER['callback_url'])
      busiu_url = "%s://%s" % [uri.scheme, uri.host]
      busiu_url += ":%d" % uri.port if uri.port != 80

      text += "= SKRAJUTĖ =\n\n" +
        busiu_url + event.flyer.public_filename + "\n\n" if event.flyer

      text += "= GROS =\n\n"
      event.stagings.each do |staging|
        text += "[ #{staging.stage.title} ]\n\n" if staging.stage

        staging.performances.each do |performance|
          artist = performance.artist
          text += "" +
            artist.title \
              + (artist.tag_list.blank? ? '' : " (#{artist.tag_list.to_s})") \
              + (performance.comment.nil? ? '' \
                : " #{Performance::COMMENT_DELIMITER} #{performance.comment}") +
            "\n"
        end
        text += "\n"
      end

      unless event.price.nil?
        text += "= KAINA =\n\n"
        text += event.free? ? "nemokamas!" : ("%d Lt" % event.price)
        text += "\n\n"
      end

      unless event.description.blank?
        description = event.description.gsub(/\[(.+?)\|(.+?)\]/, '\2 (\1)') # Replace named links
        description.gsub!(%r{(http://)?www.}, 'http://www.') # FB only supports http:// links
        text += "= APRAŠYMAS =\n\n#{description}\n\n"
      end

      text += "= ORGANIZATORIAI =\n\n" + event.organizers_as_string + "\n\n" \
        unless event.organizers.blank?

      text += "= ŽYMĖS =\n\n" + event.tag_list.to_s + "\n\n" unless event.tag_list.blank?

      text + "\n\n---------------------------------------------------------------------\n" +
        "Renginys į Facebook įdėtas per http://busiu.lt\n" +
        "Renginio būsiu.lt adresas: #{busiu_url}/renginys/" + event.slug +
        "\n\n" +
        "Įdėk ir savo renginį!\n" +
        "#{busiu_url}/renginiai/naujas"
    end
  end
end

puts '+++++++++++++++++++finished loading FacebookWorker++++++++++++++++'
# Command line usage
# FacebookWorker.send(*ARGV) if $0 == 'script/runner'
