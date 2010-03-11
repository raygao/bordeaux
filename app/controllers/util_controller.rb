################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class UtilController < ApplicationController
  def show_disclaimer
    #display disclaimer information
    @eula_status = current_user.eula_status
  end

  def set_eula_status
    #set eula status
    eula_update = params[:eula]['eula_status']
    if ((!eula_update.nil?) && (eula_update == 'yes'))
      User.find(current_user.id).update_attribute('eula_status', true)
      redirect_to home_index_path
    else
      User.find(current_user.id).update_attribute('eula_status', false)
      redirect_to show_disclaimer_util_path
    end
    puts eula_update
  end

  def generate_export_url
    # Generates the link to the do_export, because of the Facebook gateway issue.
    # Must generate a direct call URL (not gatewayed).
    ##TODO not working as of yet.
    #@export_base = 'http://' + request.env["HTTP_HOST"] + request.env['PATH_INFO']
    listings = current_user.listings
    if listings.size > 0
      @export_url =  'http://' + request.env["HTTP_HOST"] + '/util/do_export' +  "?uid=#{current_user.id}"
      # "http://web1.tunnlr.com:10337/utils/do_export" + "?uid=#{@uid}"
      logger.info @export_url
    else
      # In case the user has no listing, the export button will be disabled.
      @export_url = nil
    end
    # use :canvas => false to bypass Facebook.
    # http://forums.pragprog.com/forums/59/topics/2860
    #redirect :action => index
    # <fb:redirect url="http://apps.facebook.com/myapp/?not_in_group" />
    respond_to do |format|
      format.html # generate_export_url.html.erb
      format.fbml # generate_export_url.erb
      format.xml  { render :xml => @export_url }
    end
  end

  def do_export
    # This generates the excel file and send it back to the user
    @uid = params[:uid]
    file_handle = generate_excel_file(@uid)
    if !file_handle.nil?
      # Return the file back to the user
      file = RAILS_ROOT + "/tmp/listings-fbuser-#{current_user.facebook_id}-#{DateTime.now.strftime('%Y-%m-%d')}.xls"

      file_handle.write(file)
      send_file file,  :disposition => 'attachment'
      flash[:notice] = 'Your listing has been successfully exported.'
    else
      flash[:notice] = 'An Error occurred in exporting you file. Returning Nil content.'
    end
  end

  def generate_excel_file(uid)
    ####### now create and  the spreadsheet gem ###
    # logger.info '***Now write the spreadsheet***'

    user = User.find(uid)
    listings = user.listings

    if listings.size > 0
      book = Spreadsheet::Workbook.new
      sheet1 = book.create_worksheet :name => 'Your listings'
      sheet1.row(0).concat %w{Title Description Owner(Facebook_ID) Category Current_Status Created_at Update_at Images(following_columns)}
      header_format = Spreadsheet::Format.new :color => :blue,
        :weight => :bold,
        :size => 14
      sheet1.row(0).default_format = header_format

      #array = Array.new
      i = 0
      for listing in listings
        #item = Hash.new
        row = sheet1.row(i + 1)
        row.push listing.title
        row.push listing.description
        row.push listing.user.facebook_id
        row.push listing.category.description
        row.push listing.status
        row.push listing.created_at.to_datetime.strftime('%Y-%m-%d')
        row.push listing.updated_at.to_datetime.strftime('%Y-%m-%d')
        #show links to images on facebook (maybe multiple columns)
        if listing.photos.size > 0
          for photo in listing.photos
            row.push photo.large_fb_image
          end
        end
        #move the write cursor to the next line
        i = i+ 1
      end

      logger.info "Successfully generated the Excel file."
      return book
    else
      logger.info "An error occurred in the 'generate_excel_file' process."
      return nil
    end
  end

  def invite
    @from_user_id = facebook_session.user.to_s
    # show invite.fbml.erb page
  end

  def confirmed
    @sent_to_ids = params[:ids]
    if (@sent_to_ids.nil?)
      # if clicked the skip button, this will redirect back to the index/listings page.
      redirect_to listings_url
    end
    # If invitation has been successfully sent, show the Confirmation page.
  end

  # This show you that whether are you a group administrator?
  # <%= link_to "group info", group_info_admin_path %>

  def group_info
    #@is_group_admin = false
    @is_group_admin = 'No'
    # A faster method is using FQL. about 2x faster than facebook_session.post
    # select positions from group_member where gid = #{GROUP_ID} and uid = #{USER_ID}
    #<fql_query_response xmlns="http://api.facebook.com/1.0/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" list="true">
    #  <group_member>
    #    <positions list="true">
    #       <member_type>OWNER</member_type>   
    #       <member_type>ADMIN</member_type>
    #    </positions>
    #  </group_member>
    #</fql_query_response>
    
    @fql_results = current_user.facebook_session.fql_query(
      "select positions from group_member where gid = #{FACEBOOK_GROUP_ID} and uid = #{current_user.facebook_id}")
    # returns either empty array (size 1) or array with 1 element
    # @fql_result[0] is empty or @fql_result[0] with positions: [0], [1] ....
    for person in @fql_results
      # logger.info person['positions']
      for position in person['positions']
        if position == 'admins' || position == 'ADMIN' # now changed to 'ADMIN'
          #Facebook changed the value of member[:position] to 'ADMIN' from 'admins' on Feb 10th, without any warning.
          #@is_group_admin = true
          @is_group_admin = 'Yes'
        else
          puts '---------- not an admin ---------'
        end
        puts '-------' + position + '-------'
      end
    end
  end

  ###### Notify User, User Models/UserPublisher.rb ################
  def notify_user
    @listing = Listing.find(params[:id])
    UserPublisher.deliver_notify_user(current_user, current_user, "some message")
  end

  def get_fb_email_address
    @email_address = do_get_fb_email_address.to_s
    if !@email_address.nil?
      # Now, try to send a test mail to the user's email address
      # UserMailer.deliver_test(@email_address)
      r = MiddleMan.worker(:email_worker).async_send_test_mail(:arg => [@email_address.to_s])
      flash[:notice] = "A test message has been sent to your inbox as well."
      return @email_address
    else
      flash[:notice] = "You have not authorized this application to contact you via email yet."
      return nil
    end
  end

  def set_fb_permission
    @url_to_grant_permission = check_app_extended_permission
  end

end
