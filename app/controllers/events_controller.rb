class EventsController < ApplicationController
  # GET /events
  # GET /events.xml
  def index
    @events = Event.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.fbml # index.fbml.erb
      format.xml  { render :xml => @events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.fbml # show.fbml.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new
    @event.listing_id = params[:listing_id]  #see edit.fbml.erb from listing

    respond_to do |format|
      format.html # new.html.erb
      format.fbml # new.fbml.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    @event = Event.new(params[:event])

    respond_to do |format|
      if @event.save
        # Now, Create it a Facebook event too.
        if !savefb(@event.id).nil?
          flash[:notice] = 'Event was successfully created.'
          format.html { redirect_to(edit_listing_path(@event.listing_id)) }
          format.fbml { redirect_to(edit_listing_path(@event.listing_id)) }
          format.xml  { render :xml => @event, :status => :created, :location => @event }
        else
          @event.delete
          flash[:notice] = 'Cannot create Facebook event. Please authorize this application to create FB events for you.'
          format.html { redirect_to(edit_listing_path(@event.listing_id)) }
          format.fbml { redirect_to(edit_listing_path(@event.listing_id)) }
          format.xml  { render :xml => @event.errors, :status => "FB extened permission error" }
        end
        
        format.html { redirect_to(edit_listing_path(@event.listing_id)) }
        format.fbml { redirect_to(edit_listing_path(@event.listing_id)) }
        format.xml  { render :xml => @event, :status => :created, :location => @event }
      else
        format.html { render :action => "new" }
        format.fbml { render :action => "new" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Event was successfully updated.'
        format.html { redirect_to(@event) }
        format.fbml { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.fbml { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.fbml { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  # TODO, consider making this into a module or library
  def savefb(event_id)
    begin
      event = Event.find(event_id)
      # note 'event_info' is a hard-variable required by Facebook.
      # see following references:
      # (available parameters of the 'event_info' object ->  http://wiki.developers.facebook.com/index.php/Events.create
      # 'FacebookerWorker' is a good reference that works -> http://www.ruby-forum.com/attachment/3606/facebook_worker.rb
      # Discussions on http://groups.google.com/group/rubyonrails-talk/browse_thread/thread/98fd20ee9bfe0903
      # Facebook Error Code ->  http://wiki.developers.facebook.com/index.php/Error_codes
      # Note: must enable 'create_event' -> http://wiki.developers.facebook.com/index.php/Fb:prompt-permission
      # This has been done in the 'layout/application.fbml.erb'
      fb_event_id = facebook_session.post('facebook.events.create', { 'event_info' => facebook_event_info(event).to_json})

      #now sync with local Database.
      #Event.update_all(["facebook_event_id =?, facebook_title=?",fb_event_id, event.title], ["id=?", event.id])
      event.update_attributes({'facebook_event_id' => fb_event_id, 'facebook_title' => event.title})

      logger.info "Successfully, created an event on Facebook."
      return fb_event_id
    rescue Exception => e
      if e.message == "Creating and modifying events requires the extended permission create_event"
        logger.info "User has not authorized this application to create Facebook Event: #{e.message}"
        return nil
      else
        logger.info "An unknown error occurred: #{e.message}"
        return nil
      end
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
    start_t = (event.start_time + 10.hours).to_i
    end_t = event.end_time ? (event.end_time + 10.hours).to_i : start_t
    {
      'name' => event.title.to_s,
      'description' => event.description.to_s,
      'category' => event.category.to_s,
      'subcategory' => event.subcategory.to_s,
      'location' => event.location.to_s,
      'street' => event.street.to_s,
      'city' => event.city.to_s,
      'privacy_type' => 'OPEN', # OPEN, CLOSED, SECRET
      'start_time' => start_t,
      'end_time' => end_t,
      'phone' => event.phone,
      'email' => event.email.to_s,
      'tagline' => event.tagline.to_s,
      'page_id' => event.page_id.to_s,
      'host' => event.host.to_s,
      'facebook_event_id' => event.facebook_event_id
    }
  end

  
end
