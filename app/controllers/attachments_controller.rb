class AttachmentsController < ApplicationController
  # GET /attachments
  # GET /attachments.xml
  def index
    @attachments = Attachment.find(:all)

    respond_to do |format|
      format.html # index.html.erb
      format.fbml # index.fbml.erb
      format.xml  { render :xml => @attachments }
    end
  end

  # show the 'attachments' of a particular 'listing', which is identified by the 'id'
  def show_for_listing
    @attachments = Attachment.find_all_by_listing_id(params[:id])

    respond_to do |format|
      format.html # show_for_listing.html.erb
      format.fbml # show_for_listing.fbml.erb
      format.xml  { render :xml => @attachments }
    end
  end

  # GET /attachments/1
  # GET /attachments/1.xml
  # show an 'attachment'
  def show
    @attachment = Attachment.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.fbml # show.fbml.erb
      format.xml  { render :xml => @attachment }
    end
  end

  # download attachment
  def download
    @attachment = Attachment.find(params[:id])
    file = RAILS_ROOT + '/public' + @attachment.public_filename
    #    send_file file, :type => 'application/octet',  :disposition => 'attachment'
    send_file file, :disposition => 'attachment'
  end

  
  # GET /attachments/new
  # GET /attachments/new.xml
  def new
    @attachment = Attachment.new

    respond_to do |format|
      format.html # new.html.erb
      format.fbml # new.fbml.erb
      format.xml  { render :xml => @attachment }
    end
  end

  # GET /attachments/1/edit
  def edit
    @attachment = Attachment.find(params[:id])
    @download_url =  'http://' + request.env["HTTP_HOST"] + "/attachments/#{@attachment.id}/download"
    # "http://web1.tunnlr.com:10337/attachment/download" + "?id=#{@id}"
  end

  # POST /attachments
  # POST /attachments.xml
  def create
    @attachment = Attachment.new(params[:attachment])

    respond_to do |format|
      if @attachment.save
        flash[:notice] = 'Attachment was successfully created.'
        format.html { redirect_to FB_APP_HOME_URL + show_for_listing_attachment_path( params[:attachment][:listing_id]) }
        format.fbml { redirect_to FB_APP_HOME_URL + show_for_listing_attachment_path( params[:attachment][:listing_id]) }

        #format.html { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:attachment][:listing_id]) }
        #format.fbml { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:attachment][:listing_id]) }
        format.xml  { render :xml => @attachment, :status => :created, :location => @attachment }
      else
        flash[:notice] = 'Cannot save the attachment.'
        #TODO flash[:notice] cannot pass back to the Facebook App domain.
        flash[:notice] = 'Cannot save attachment .'
        format.html { redirect_to FB_APP_HOME_URL + show_for_listing_attachment_path( params[:attachment][:listing_id]) }
        format.fbml { redirect_to FB_APP_HOME_URL + show_for_listing_attachment_path( params[:attachment][:listing_id]) }

        #format.html { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:attachment][:listing_id]) }
        #format.fbml { redirect_to FB_APP_HOME_URL + edit_listing_path(params[:attachment][:listing_id]) }
        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # PUT /attachments/1
  # PUT /attachments/1.xml
  def update
    @attachment = Attachment.find(params[:id])
    @attachment_parent_listing_id = @attachment.listing_id

    respond_to do |format|
      if @attachment.update_attributes(params[:attachment])
        flash[:notice] = 'Attachment was successfully updated.'
        format.html { redirect_to(show_for_listing_attachment_path(@attachment_parent_listing_id )) }
        format.fbml { redirect_to(show_for_listing_attachment_path(@attachment_parent_listing_id )) }

        #format.html { redirect_to edit_listing_path(@attachment_parent_listing_id) }
        #format.fbml { redirect_to edit_listing_path(@attachment_parent_listing_id) }
        format.xml  { head :ok }
      else
        flash[:notice] = 'Cannot update attachment.'
        format.html { render :action => "edit" }
        format.fbml { render :action => "edit" }
        format.xml  { render :xml => @attachment.errors, :status => :unprocessable_entity }
      end
    end
  end

  # DELETE /attachments/1
  # DELETE /attachments/1.xml
  def destroy
    @attachment = Attachment.find(params[:id])
    @attachment_parent_listing_id = @attachment.listing_id
    @attachment.destroy

    respond_to do |format|
      flash[:notice] = "Attachment deleted."
      format.html { redirect_to(show_for_listing_attachment_path(@attachment_parent_listing_id )) }
      format.fbml { redirect_to(show_for_listing_attachment_path(@attachment_parent_listing_id )) }

      #format.html { redirect_to(edit_listing_path(@attachment_parent_listing_id)) }
      #format.fbml { redirect_to(edit_listing_path(@attachment_parent_listing_id)) }
      format.xml  { head :ok }
    end
  end
end