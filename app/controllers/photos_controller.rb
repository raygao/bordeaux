class PhotosController < ApplicationController
  # GET /photos
  # GET /photos.xml
  def index
    @photos = Photo.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.fbml # index.fbml.erb
      format.xml  { render :xml => @photos }
    end
  end

  # show the 'photos' of a particular 'listing', which is identified by the id
  def show_for_listing
    @photos = Photo.find_all_by_listing_id(params[:id])

    respond_to do |format|
      format.html # show_for_listing.html.erb
      format.fbml # show_for_listing.fbml.erb
      format.xml  { render :xml => @photos }
    end
  end

  # GET /photos/1
  # GET /photos/1.xml
  # show a 'photo'
  def show
    @photo = Photo.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.fbml # show.fbml.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/new
  # GET /photos/new.xml
  def new
    @photo = Photo.new

    respond_to do |format|
      format.html # new.html.erb
      format.fbml # new.fbml.erb
      format.xml  { render :xml => @photo }
    end
  end

  # GET /photos/1/edit
  def edit
    @photo = Photo.find(params[:id])
  end

  # POST /photos
  # POST /photos.xml
  def create
    @photo = Photo.new(params[:photo])
    respond_to do |format|
      begin
        if @photo.save
          data = File.open(RAILS_ROOT.to_s + '/public' + @photo.public_filename).read
          file_parameter = Net::HTTP::MultipartPostFile.new(@photo.filename, @photo.content_type, data)
          fb_image = facebook_session.user.upload_photo(file_parameter)

          #fb_image has 3 url, .src -> medium, .src_big -> original, .src_small -> thumbnail
          #using hash to update the large and small images on facebook.
          fb_image_links = {'large_fb_image' => fb_image.src_big, 'small_fb_image' => fb_image.src_small}
          @photo.update_attributes(fb_image_links)

          flash[:notice] = 'Photo was successfully added.'
          format.html { redirect_to FB_APP_HOME_URL + show_for_listing_photo_path( params[:photo][:listing_id]) }
          format.fbml { redirect_to FB_APP_HOME_URL + show_for_listing_photo_path( params[:photo][:listing_id]) }
          format.xml  { render :xml => @photo, :status => :created, :location => @photo }

          #format.html { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:photo][:listing_id]) }
          #format.fbml { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:photo][:listing_id]) }
          #format.xml  { render :xml => @photo, :status => :created, :location => @photo }
        else
          flash[:notice] = 'Cannot save the photo.'
          #TODO flash[:notice] cannot pass back to the Facebook App domain.
          format.html { redirect_to FB_APP_HOME_URL + show_for_listing_photo_path( params[:photo][:listing_id]) }
          format.fbml { redirect_to FB_APP_HOME_URL + show_for_listing_photo_path( params[:photo][:listing_id]) }

          #format.html { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:photo][:listing_id]) }
          #format.fbml { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:photo][:listing_id]) }
          format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
        end
      rescue Facebooker::Session::UnknownError => fb_unkwn_err
        flash_text = "Cannot save your image onto Facebook: #{fb_unkwn_err.to_s}"
        logger.info "*****#{flash_text}***"
        @photo.destroy
        flash[:notice] = flash_text
        format.html { redirect_to FB_APP_HOME_URL + show_for_listing_photo_path( params[:photo][:listing_id]) }
        format.fbml { redirect_to FB_APP_HOME_URL + show_for_listing_photo_path( params[:photo][:listing_id]) }

        #format.html { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:photo][:listing_id]) }
        #format.fbml { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:photo][:listing_id]) }
        format.xml  { render :xml => @photo, :status => :created, :location => @photo }
      end
    end
  end

  def upload_photo(multipart_post_file, options = {})
    Photo.from_hash(session.post_file('facebook.photos.upload',
        options.merge(nil => multipart_post_file)))
  end

  # PUT /photos/1
  # PUT /photos/1.xml
  def update
    @photo = Photo.find(params[:id])
    @photo_parent_listing_id = @photo.listing_id

    respond_to do |format|
      if @photo.update_attributes(params[:photo])
        flash[:notice] = 'Photo was successfully updated.'
        format.html { redirect_to(show_for_listing_photo_path(@photo_parent_listing_id )) }
        format.fbml { redirect_to(show_for_listing_photo_path(@photo_parent_listing_id )) }

        #format.html { redirect_to edit_listing_path(@photo_parent_listing_id) }
        #format.fbml { redirect_to edit_listing_path(@photo_parent_listing_id) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Cannot update photo.'
        format.html { render :action => "edit" }
        format.fbml { render :action => "edit" }
        format.xml  { render :xml => @photo.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /photos/1
  # DELETE /photos/1.xml
  def destroy
    @photo = Photo.find(params[:id])
    @photo_parent_listing_id = @photo.listing_id
    @photo.destroy

    respond_to do |format|
      flash[:notice] = "Photo deleted."
      format.html { redirect_to(show_for_listing_photo_path(@photo_parent_listing_id )) }
      format.fbml { redirect_to(show_for_listing_photo_path(@photo_parent_listing_id )) }
      
      #format.html { redirect_to(edit_listing_path(@photo_parent_listing_id)) }
      #format.fbml { redirect_to(edit_listing_path(@photo_parent_listing_id)) }
      format.xml  { head :ok }
    end
  end
end
