################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

# $ script/generate facebook_publisher User
# rake db:migrate
#
class UserPublisher < Facebooker::Rails::Publisher

  ###################################################
  ### Made obsolete by Facebook's new layout.     ###
  ### profile section                             ###
  ### see views/utils/_profile.erb                ###
  ### u= User.find(#)                             ###
  ### UserPublisher.create_profile_update(u)      ###
  ### UserPublisher.deliver_profile_update(u)     ###
  ###################################################

  def profile_update(user)
    begin
      send_as :profile
      recipients user
      #this goes to the boxes
      profile render(:partial => "util/profile",
        :assigns => {:user => user})
      #this goes to the wall on front page
      profile_main render(:partial => "util/profile_main",
        :assigns => {:user => user})
    end
  end

  ################################################################
  # Notify User box is located at the bottom right of the screen #
  # This will no longer supported by Facebook, after March 1st   #
  # TODO change into stream and email per Facebook Roadmap       #
  # http://wiki.developers.facebook.com/index.php/Developer_Roadmap
  #  NO LONGER VALID, Facebook has turn those off!!!!            #
  ################################################################
  # deprecated by notify_user method
  def old_notify_user (listing, sender, receiver)
    send_as :notification
    from sender.facebook_session.user    
    recipients receiver.facebook_session.user
    #fbml "<a href='#{FB_APP_HOME_URL}/listings/#{listing.id}'><b>#{listing.title}</b></a> has been approved."
    fbml "Your listing: <a href='#{listings_path(listing.id)}}'><b>#{listing.title}</b></a> has been approved."
  end

  def notify_user (message, sender, receiver)
    send_as :notification
    from sender.facebook_session.user
    recipients receiver
    fbml message
  end
  
  #****************************************************************************#
  # This uses Facebook's new stream API. It replaces Facebooker's publisher.   #
  # Technically, it should be in a different file. But, I am lumping it here   #
  # until the next release.                                                    #
  #****************************************************************************#
  def post_to_wall (message, sender, receiver_fb_id)
    begin
      sender.facebook_session.post('facebook.stream.publish', {:message => message, :target_id => receiver_fb_id})
      logger.info("Write on receiver #{receiver_fb_id}'s wall: #{message} by #{sender.facebook_id}")
    rescue Exception => e
      logger.info "Exception occurred in posting to the user's wall: #{e.message}"
    end
  end


  #****************************************************************************#
  # legacy code, made obsolete by Facebook's changes. use stream API           #
  #****************************************************************************#

  # UserPublisher.register_XXX & UserPublisher.deliver_XXX is
  # no longer supported by Facebook, ########################
  # see http://forums.pragprog.com/forums/59/topics/4000 ####
  ### Need to use Stream API ################################

  ###########################################################
  ### News feed section                                   ###
  ### see utils/_profile.erb                              ###
  ### listing=Listing.find(:last)                         ###
  ### UserPublisher.register_listing_added                ###
  ### UserPublisher.deliver_listing_added(listing)        ###
  ###########################################################
  def listing_added_template
    one_line_story_template "{*actor*} added following: {*show_link*} to his/her library."
    short_story_template "{*actor*} added following. ", "It is {*show_link*}."
  end

  #Provides data for the above template with the same name"
  def listing_added (listing)
    send_as :user_action
    from listing.user.facebook_session.user
    data :show_link => link_to(listing.title, listing_url(listing.id))
  end

end