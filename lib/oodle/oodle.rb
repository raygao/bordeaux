################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

require 'rubygems'
require 'httparty'
require 'json'
require 'json/ext'


class Oodle
  include HTTParty
  #base_uri 'api.oodle.com/api/v2/listings?key=########&format=json&jsoncallback=none&'
  base_uri 'api.oodle.com'
  default_params :output => 'json'
  format :json

  #http://api.oodle.com//api/v2/listings?key=#######&region=dallas&q=porchbbs

  def self.get_by_keyword(query, region)
    get('/api/v2/listings?key=#######&format=json&jsoncallback=none&',
      :query => {:q => query, :region => region})
  end

end

class OodleLookup
  def logger
    #RAILS_DEFAULT_LOGGER
    begin
      return RAILS_DEFAULT_LOGGER
    rescue
       # if running as a command app
       return Logger.new('../log/oodle_log.txt')
    end
  end

  def get_listings(query, region)

    begin
      results = Oodle.get_by_keyword(query, region)
      if ((results['listings'].nil?) || (results['listings'].size < 1))
        #logger.info "No suitable listing was found in Oodle."
        return nil
      end

      listings = results['listings']

      items = Array.new
      i = 0

      logger.info "*" * 80
      #logger.info "Found " + listings.size.to_s + " listings."
      logger.info "*" * 80

      listings.each do |each|
        logger.info "-" * 80

        item = Hash.new


        item['title'] = each['title']
        item['category'] = each['category']
        item['body'] = each['body']
        item['url'] = each['url']
        #item['images'] = each['images']

        logger.info "Title: " + item['title']
        logger.info "Category Name: "  + item['category']['name'] + \
                    ", category ID: "  + item['category']['id']
        logger.info "Body: " + item['body']
        logger.info "Url: " + item['url']
        #logger.info 'Images ' + item['images']

        items[i] = item
        i = i + 1

      end
      if items.size > 0
        puts "***returning #{items.size} listings from Oodle***"
        return items
      else
        return nil
      end
    rescue Error => err
      #logger.info "An Error occurred in OodleLookup: " + err.message
      return nil
    rescue Exception => ex
      #logger.info "An Exception occurred in OodleLookup: " + ex.message
      return nil

    end

  end
end