################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class ListingsController < ApplicationController
  # GET /listings
  # GET /listings.xml
  def index
    #@listings = Listing.find_all_by_user_id(current_user)
    if params[:category_id]
      if params[:user_id].to_s == current_user.id.to_s
        # for current user, show everything in a category, including private, pending, expired, as well as public
        @listings = Listing.find_all_by_user_id_and_category_id(current_user, params[:category_id]).paginate :page => params[:page],
          :per_page => LISTING_PER_PAGE
      elsif !params[:user_id].nil?
        # show only public listings of other user
        @listings = Listing.find_all_by_user_id_and_category_id_and_status(params[:user_id].to_s, params[:category_id], 'public').paginate :page => params[:page],
          :per_page => LISTING_PER_PAGE
      else
        #otherwise, only show public listings in a category.
        @listings = Listing.find_all_by_category_id_and_status(params[:category_id], 'public').paginate :page => params[:page],
          :per_page => LISTING_PER_PAGE
      end
    else
      # Show all listings of the current user
      @listings = Listing.find_all_by_user_id(current_user).paginate :page => params[:page],
        :per_page => LISTING_PER_PAGE
    end

    respond_to do |format|
      remove_fb_sig_friends_from_params
      format.html # index.html.erb
      format.fbml # index.fbml.erb
      format.xml  { render :xml => @listings }
    end
  end

  # GET /listings/1
  # GET /listings/1.xml
  def show
    begin
      @listing = Listing.find(params[:id])
    rescue Exception => e
      if e.class == ActiveRecord::RecordNotFound
        logger.info("No such listing by id: #{params[:id]}")
      end
      @listing = nil
      return false
    end

    if @listing.user_id == current_user.id 
      @is_owner = true
      @private_listing = false
    elsif verify_admin_status == true
      @is_admin = true
      @private_listing = false
    else
      @is_owner = false
      if @listing.private?
        @private_listing = true
      end
    end

    respond_to do |format|
      remove_fb_sig_friends_from_params
      format.html # show.html.erb
      format.fbml # show.fbml.erb
      format.xml  { render :xml => @listing }
    end
  end

  # GET /listings/new
  # GET /listings/new.xml
  def new
    @listing = Listing.new

    respond_to do |format|
      format.html # new.html.erb
      format.fbml # new.fbml.erb
      format.xml  { render :xml => @listing }
    end
  end

  # GET /listings/new2
  # GET /listings/new2.xml
  def new2
    #does not allow attaching a picture
    @listing = Listing.new

    respond_to do |format|
      format.html # new.html.erb
      format.fbml # new.fbml.erb
      format.xml  { render :xml => @listing }
    end
  end

  # GET /listings/1/edit
  def edit
    respond_to do |format|
      @listing = Listing.find(params[:id])
      format.html #
      format.fbml #
      format.xml  { render :xml => nil }
    end
  end

  # POST /listings
  # POST /listings.xml
  def create
    @listing = Listing.new
    @listing.title=params[:listing][:title]
    @listing.description=params[:listing][:description]
    # TODO, what if the no category has been created yet?
    if params[:listing][:category_id].nil?
      cat = Category.find_by_description('default')
      if cat.nil?
        cat = Category.new
        cat.description = 'default'
        cat.save!
      end
      @listing.category_id = cat.id
    else
      @listing.category_id = params[:listing][:category_id]
    end
    @listing.user_id = current_user.id #need user id

    respond_to do |format|
      begin
        if @listing.save
          flash[:notice] = 'Your listing has been added, awaiting group admin approval.'
          # Now log it to the small box in my profile.
          UserPublisher.deliver_profile_update(current_user)

          #Now, check for attachment file. If it exists, save it.
          #TODO, need to extract it & make it into a utility method along with PhotosController.rb
          if (!params[:listing][:uploaded_data].nil?)
            photo_info = Hash.new
            photo_info[:uploaded_data] = params[:listing][:uploaded_data]
            photo_info[:listing_id] = @listing.id.to_s
            if (!params[:photo][:title].nil?)
              photo_info[:title] = params[:photo][:title]
            end
            @photo = Photo.new(photo_info)
            if @photo.save
              data = File.open(RAILS_ROOT.to_s + '/public' + @photo.public_filename).read
              file_parameter = Net::HTTP::MultipartPostFile.new(@photo.filename, @photo.content_type, data)
              fb_image = facebook_session.user.upload_photo(file_parameter)

              #fb_image has 3 url, .src -> medium, .src_big -> original, .src_small -> thumbnail
              #using hash to update the large and small images on facebook.
              fb_image_links = {'large_fb_image' => fb_image.src_big, 'small_fb_image' => fb_image.src_small}
              @photo.update_attributes(fb_image_links)
            end
          end

          # Back to main listing page
          format.html { redirect_to(FB_APP_HOME_URL + listings_path) }
          format.fbml { redirect_to(FB_APP_HOME_URL + listings_path) }
          format.xml  { render :xml => @listing, :status => :created, :location => @listing }

          #with new2, which does not allow image upload on new listing creation.
          #format.html { redirect_to(listings_path) }
          #format.fbml { redirect_to(listings_path) }
          #format.xml  { render :xml => @listing, :status => :created, :location => @listing }
        else
          flash[:notice] = 'Cannot create your listing!'
          format.html { redirect_to FB_APP_HOME_URL + listings_path, :action => "new" }
          format.fbml { redirect_to FB_APP_HOME_URL + listings_path, :action => "new" }
          format.xml  { render :xml => @listing.errors, :status => :unprocessable_entity }
        end
      rescue Exception => e
        flash_text = "An error occurred in creating the listing: #{e.to_s}"
        logger.info "*****#{flash_text}***"
        @listing.destroy
        flash[:notice] = flash_text
        format.html { redirect_to FB_APP_HOME_URL + listings_path, :action => "new" }
        format.fbml { redirect_to FB_APP_HOME_URL + listings_path, :action => "new" }
        format.xml  { render :xml => @listing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /listings/1
  # PUT /listings/1.xml
  def update
    @listing = Listing.find(params[:id])
    respond_to do |format|
      if (@listing.user_id != current_user.id && !verify_admin_status)
        flash[:notice] = 'You don not have right to edit this listing.'
        format.html { redirect_to(@listing) }
        format.fbml { redirect_to(@listing) }
        format.xml  { head :ok }
      elsif @listing.update_attributes(params[:listing])
        flash[:notice] = 'Listing was successfully updated.'
        format.html { redirect_to(@listing) }
        format.fbml { redirect_to(@listing) }
        format.xml  { head :ok }
      else
        flash[:notice] = "Cannot update the listing!"
        format.html { render :action => "edit" }
        format.fbml { render :action => "edit" }
        format.xml  { render :xml => @listing.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /listings/1
  # DELETE /listings/1.xml
  def destroy
    @listing = Listing.find(params[:id])
    @listing.destroy
    respond_to do |format|
      #only Group admin or Listing owner can delete a listing.
      if (@listing.user_id != current_user.id && !verify_admin_status)
        flash[:notice] = 'You don not have right to delete this listing.'
        format.html { redirect_to(@listing) }
        format.fbml { redirect_to(@listing) }
        format.xml  { head :ok }
      else
        @listing.destroy
        flash[:notice] = "Listing deleted."
        format.html { redirect_to(listings_url) }
        format.fbml { redirect_to(listings_url) }
        format.xml  { head :ok }
      end
    end
  end

  def show_pending
    respond_to do |format|
      if verify_admin_status == true
        @pending = Listing.find_all_by_status("pending").paginate :page => params[:page], :per_page => LISTING_PER_PAGE
        remove_fb_sig_friends_from_params
        format.html # show_pending.html.erb
        format.fbml # show_pending.fbml.erb
        format.xml  { render :xml => @pending, :status => :ok, :location => @listing }
      else
        flash[:notice] = "you are not a group admin. You don't have authority to see pending/unapproved listings."
        format.html { redirect_to listings_path }  # index.html.erb
        format.fbml { redirect_to listings_path }  # index.fbml.erb
        format.xml  { render :xml => @pending.errors, :status => :unprocessable_entity }
      end
    end

  end

  def approve
    @result = false
    current_user.facebook_session
    # before_filter :verify_admin_status
    respond_to do |format|
      if verify_admin_status == false
        flash[:notice] = "you are not a group admin. You don't have authority to approve a listing."
        format.html { redirect_to listings_path }  # show.html.erb
        format.fbml { redirect_to listings_path }  # show.fbml.erb
        format.xml  { render :xml => nil, :status => :unprocessable_entity }
      else
        @listing_id = params[:id]
        @listing = Listing.find(@listing_id)
        @result = @listing.approve!
        flash[:notice] = "You have approved #{@listing.title}."
        message = "<a href='#{listings_path(@listing.id)}}'>#{@listing.title}</a> has been approved."
        # Use Facebook's notification service, no longer valid, facebook has turned it off.
        #result = UserPublisher.deliver_notify_user(message, current_user, @listing.user)
        # Post to user's wall, only when a listing is approved, it writes on the
        # listing owner's wall
        up = UserPublisher.new
        #up.post_to_wall("Your listing has been approved.", current_user, @listing.user.facebook_id)
        begin
          up.post_to_wall("A new listing: \'#{@listing.title}\' has been made public. Goto #{listings_url(@listing.id)}", current_user, @listing.user.facebook_id)
        rescue Facebooker::Session::PermissionError => perm_err
          logger.error("This user has not authorized the application to post to his/her wall. " + perm_err.to_s)
        end

        # using email to notify the user about listing approval
        # TODO using backgroundrb to send it in the background process
        begin
          if !@listing.user.fb_email.nil?
            # Calling synchronized could lock the controller. This is not a good idea.
            # result = UserMailer.deliver_approval(@listing.user.fb_email, @listing.title, @listing.id)
            # Using Backgroundrb to do the email delivery.
            r = MiddleMan.worker(:email_worker).async_send_approval_mail(:arg => [@listing.user.fb_email, @listing.title, @listing.id])
            logger.info("Listing approved. Emailing notification to user.")
          else
            logger.info("Cannot email user, no valid email address on file.")
          end
        rescue Exception => e
          logger.error("An exception occurred in sending email to user. type: #{e.class}, message: #{e.to_s}")
        end
        
        #refresh the web page
        format.html { redirect_to(show_pending_listings_path) }  # show_pending.html.erb
        format.fbml { redirect_to(show_pending_listings_path) }  # show_pending.fbml.erb
        format.xml  { render :xml => @listings }
        #format.html { redirect_to(@listing) }  # show.html.erb
        #format.fbml { redirect_to(@listing) }  # show.fbml.erb
        #format.xml  { render :xml => @listings }
      end
    end
  end

  def reject
    @result = false
    respond_to do |format|
      if verify_admin_status == false
        flash[:notice] = "You are not a group admin. You don't have authority to approve a listing."
        format.html { redirect_to listings_path }  # show.html.erb
        format.fbml { redirect_to listings_path }  # show.fbml.erb
        format.xml  { render :xml => nil, :status => :unprocessable_entity }
      else
        @listing_id = params[:id]
        @listing = Listing.find(@listing_id)
        @result = @listing.reject!
        flash[:notice] = "You have rejected #{@listing.title}."
        message = "<a href='#{listings_path(@listing.id)}}'>#{@listing.title}</a> has been rejected."
        # Use Facebook's notification service, no longer valid, facebook has since turned it off
        #result = UserPublisher.deliver_notify_user(message, current_user, @listing.user)
        # Post to user's wall
        # If it is reject, there is no sense to write on the listing owner's wall

        # using email to notify the user about listing rejection
        # TODO using backgroundrb to send it in the background process
        begin
          if !@listing.user.fb_email.nil?
            # Calling synchronized could lock the controller. This is not a good idea.
            # result = UserMailer.deliver_rejection(@listing.user.fb_email, @listing.title, @listing.id)
            # Using Backgroundrb to do the email delivery.
            # TODO email is the current user's email, sent to wrong user. should be the
            # email address of the listing owner

            r = MiddleMan.worker(:email_worker).async_send_rejection_mail(:arg => [@listing.user.fb_email, @listing.title, @listing.id])
            logger.info("Listing rejected. Emailing notification to user.")
          else
            logger.info("Cannot email user, no valid email address on file.")
          end
        rescue Exception => e
          logger.error("An exception occurred in sending email to user. type: #{e.class}, message: #{e.to_s}")
        end

        #refresh the web page
        format.html { redirect_to(show_pending_listings_path) }  # show_pending.html.erb
        format.fbml { redirect_to(show_pending_listings_path) }  # show_pending.fbml.erb
        format.xml  { render :xml => @listings }
        #format.html { redirect_to(@listing) }  # show.html.erb
        #format.fbml { redirect_to(@listing) }  # show.fbml.erb
        #format.xml  { render :xml => @listings }
      end
    end
  end

end