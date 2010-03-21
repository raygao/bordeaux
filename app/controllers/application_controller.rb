# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.
require RAILS_ROOT + '/lib/constants'

class ApplicationController < ActionController::Base

  helper :all # include all helpers, all the time

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery  #:secret => '049ceb982d1b6b17b968554ed1a94c03'

  include FacebookerAuthentication::Controller

  # See http://forums.pragprog.com/forums/59/topics/3576 , about too many redirect
  before_filter :facebook_login_required, :except => :utils
  before_filter :session_expiry #sets up session expirtion policy
  before_filter :do_get_fb_email_address #populates the user's fb_email
  # TODO this before_filter is a potential performance bottleneck, it is not very good
  # looking for a better strategy. For the time being, using the caching strategy in
  # the 'do_get_fb_email_address' method

  #ensure_application_is_installed_by_facebook_user
  ensure_authenticated_to_facebook

  # See ActionController::Base for details
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password").
  # filter_parameter_logging :password

  #additional helper methods for this application
  #
  #######################################
  # redirects to the app home page      #
  #######################################
  # TODO need to define dev, stage, and production
  def route_to_home
    redirect_to FB_APP_HOME_URL
  end

  #########################################
  # verify if a user belongs to the group #
  #########################################
  def verify_user_group_membership
    # Use session cache, to avoid querying Facebook. This is done for performance reason
    if session[current_user.facebook_id.to_s + ':membership'] == 'verified'
      # group membership already verified
      return true
    end

    user_s_groups = facebook_session.user.groups

    # checking for being a member of the group
    begin
      if (!user_s_groups.nil?)
        for group in user_s_groups
          if (group.gid.to_i == FACEBOOK_GROUP_ID.to_i)
            session[current_user.facebook_id.to_s + ':membership'] = 'verified'
            logger.info "***Group <#{group.gid}> membership has been Verified for user #{current_user['facebook_id']}.}***"
            return true
          end
        end
      else
        # User has not joined that group
        logger.info "***User: #{current_user['facebook_id']} is not in group: #{FACEBOOK_GROUP_ID.to_i}***"
        return false
      end

      # if the user does not have any groups, return false
      return false
    rescue Exception => e
      logger.error("Error in verify_user_group_membership, #{e.message}")
    end
  end

  #######################################
  # time to expire the session          #
  #######################################
  def session_expiry
    reset_session if session[:expiry_time] and session[:expiry_time] < Time.now

    session[:expiry_time] = MAX_SESSION_PERIOD.seconds.from_now
    return true
  end

  #######################################
  # verify if a user is a group admin?  #
  #######################################
  def verify_admin_status
    #reset_session # for testing purpose
    #super user can always access the admin functions
    #super_user_id is 0, means everyone is a group admin.
    if (current_user.facebook_id == SUPER_USER_ID) || (SUPER_USER_ID == 0)
      logger.info current_user.facebook_id.to_s + " is SUPER-USER of group: #{FACEBOOK_GROUP_ID}"
      session[current_user.facebook_id.to_s + ":admin"] = "admin"
      return true
    end

    #using session as a caching mechanism, because Facebook Query for group is
    #very slow, about 5 seconds for a group with 400+ members
    if session[current_user.facebook_id.to_s + ":admin"] == "admin"
      logger.info "Session cache: " + current_user.facebook_id.to_s + " is #{session[current_user.facebook_id.to_s + ":admin"]} of group: #{FACEBOOK_GROUP_ID}"
      return true
    elsif session[current_user.facebook_id.to_s + ":admin"] == "member"
      logger.info "Session cache: " + current_user.facebook_id.to_s + " is #{session[current_user.facebook_id.to_s + ":admin"]} of group: #{FACEBOOK_GROUP_ID}"
      return false
    end

    begin
      @is_group_admin = false
      # When a group has over 500 members, the 'facebook.groups.getMembers' Rest API returns random number of users.
      # Therefore, the following method is not reliable. See http://wiki.developers.facebook.com/index.php/Group_member_%28FQL%29
      # result = facebook_session.post('facebook.groups.getMembers', :gid => FACEBOOK_GROUP_ID)

      # Using FQL insure getting the accurate result.
      query = "select uid,positions from group_member where gid=#{FACEBOOK_GROUP_ID} and uid=#{current_user.facebook_id.to_s}"
      result = current_user.facebook_session.fql_query(query)

      for member in result
        for position in member['positions']
          if (position == 'admins' || position == 'ADMIN')
          
            #Facebook changed the value of member['position'][#] to 'ADMIN' from 'admins' on Feb 10th, without any warning.
            #Facebook uses 'positions[#]' for 'ADMIN' & "OFFICER". Regular group member returns a null string.
            @is_group_admin = true
            session[current_user.facebook_id.to_s + ":admin"] = "admin"
            logger.info current_user.facebook_id.to_s + " is #{position} of group: #{FACEBOOK_GROUP_ID}"
            return @is_group_admin
          end
        end
      end
      # If the user is not an admin, he/she must be a member of a FB group.
      session[current_user.facebook_id.to_s + ":admin"] = "member"
      return @is_group_admin
    rescue Exception => e
      logger.error("Error in verify_admin_status, #{e.message}")
    end

  end

  #########################################
  # Removes fb_sig_friends from the param #
  #########################################
  def remove_fb_sig_friends_from_params
    # Facebook Gateway has a length limit, 'fb_sig_friends' could contain hundreds of IDS and be very long.
    # Because will_paginate puts everything in the generated string, Facebook would not accept such long URL.
    # Problems has been observed in both the 'home', 'listing, and 'search' controllers.
    params['fb_sig_friends'] = nil
  end

  #########################################
  # Returns User's email address, fb/db   #
  #########################################
  def do_get_fb_email_address
    # First, look for it in the local db. If it is not there, get it from Facebook.
    # This is a caching strategy, making remote call is more expensive than find it in the local DB.

    if (!current_user.fb_email.nil? || !session[current_user.facebook_id.to_s + ':fb_email_address'].nil?)
      #either in the database or in the current session
      @email_address = current_user.fb_email.to_s
      return @email_address
    else
      # Facebook has changed the return result, with an array of two elements,
      # The first element is the uid
      # The second element(array) contains the email address
      # There is a bug with Facebooker, it only retries the 1st element of the array. And, shift rest to nothing see def fql_query(query, format = 'XML') method
      # fql_results = current_user.facebook_session.fql_query(
      #  "select email from user where uid = #{current_user.facebook_id}")
      # <?xml version="1.0" encoding="UTF-8"?>
    
      #<fql_query_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" list="true">
      #    <user>
      #      <email>email_address@yahoo.com</email>
      #    </user>
      #</fql_query_response>
    
      # TODO, refactor this method, and fix facebook/facebooker conflict.
      @email_address = nil
      begin
        query = "select email from user where uid = #{current_user.facebook_id}"
        fql_response = current_user.facebook_session.post('facebook.fql.query', :query => query, :format => 'XML')
        # The result is an array of array. The first element contains string: 'user'. The second one is an array which contains email address
        for fql_response_elements in fql_response
          if !fql_response_elements.nil?
            # result can be [0] =>'user' or [1] => an array of values, containing 'email'
            if (fql_response_elements.class == Array)
              for element in fql_response_elements
                if !element['email'].nil?
                  @email_address = element['email'].to_s
                  #update the database
                  u = User.find_by_facebook_id(current_user.facebook_id)
                  u.update_attributes(:fb_email => @email_address)
                  # update the current_user as well for the safety reason
                  current_user.fb_email = @email_address
                  u.save!
                  logger.info "User's email is: <" + @email_address + ">. It has been updated in the database."
                end
              end
            end
          end
        end

        #builds session caching mechanism for the email_address
        if @email_address.nil?
          session[current_user.facebook_id.to_s + ':fb_email_address'] = 'not provided'
        else
          session[current_user.facebook_id.to_s + ':fb_email_address'] = @email_address
        end
        
        return @email_address
      rescue Exception => e
        logger.info "An exception occurred in the do_get_fb_email_address function: " + e.message.to_s
        return nil
      end
    end
  end

  def check_app_extended_permission
    # return nil, if all the needed permissions has already been authorized.
    options = Hash.new
    options = {'key1' => 1, 'key2' => 2}

    #go from current_user -> facebook_session -> Facebooker::User --> has_permission
    #fb_user = current_user.facebook_session.user
    #email_perm = fb_user.has_permission?("publish_stream").to_s
    #proxy_mail = fb_user.proxied_email

    #this does not work.
    #query = "select uid, status_update, photo_upload, sms, offline_access, email, create_event, rsvp_event, publish_stream, read_stream, share_item, create_note, bookmarked from permissions where uid=#{current_user.facebook_id}"

    query = "select offline_access, email, create_event, rsvp_event, publish_stream, read_stream from permissions where uid=#{current_user.facebook_id}"
    fql_response = current_user.facebook_session.post('facebook.fql.query', :query => query, :format => 'XML')

    # The result is:
=begin
<?xml version="1.0" encoding="UTF-8"?>
    <fql_query_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" list="true">
      <permissions>
        <uid>fb_user_id</uid>
        <status_update>1</status_update>
        <photo_upload>1</photo_upload>
        <sms>0</sms>
        <offline_access>1</offline_access>
        <email>1</email>
        <create_event>1</create_event>
        <rsvp_event>1</rsvp_event>
        <publish_stream>1</publish_stream>
        <share_item>1</share_item>
        <create_note>1</create_note>
        <bookmarked>0</bookmarked>
      </permissions>
    </fql_query_response>
=end
    #but, facebooker does not understand the XML Doom structure

    if (fql_response[0] == 'permissions')
      for item in fql_response[1]
        for key in item.keys
          if (item[key] == '0')
            # if the item[key] is '0', it means that that particular permission has not be authorized.
            # if the item[key] is '1', it means that that particular permission has already been authorized.
            @url_for_permission = facebook_session.connect_permission_url('email,publish_stream,read_stream,create_event,rsvp_event,offline_access', options)
            logger.info("User has not yet granted permission: #{item[key]} to this app.")
            return @url_for_permission
          end
        end
      end
    end

    logger.info("User has already granted all permissions to this app.")
    return @url_for_permission

  end

  # returns the name of the group, if not found, just use the constant
  def get_group_name(gid)
    group = facebook_session.post('facebook.groups.get', :gids => FACEBOOK_GROUP_ID)
    name = group[0]['name']
    if !name.nil?
      return name
    else
      return FACEBOOK_GROUP_NAME
    end
  end
  #######################################
  # declares above as helper methods    #
  #######################################
  helper_method :verify_user_group_membership
  helper_method :route_to_home
  helper_method :verify_admin_status
  helper_method :do_get_fb_email_address
  helper_method :check_app_extended_permission
  helper_method :get_group_name

end