################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class AdminController < ApplicationController

  before_filter :verify_admin_status
  
  def index

  end

  def show

  end

  def expire_stale_listings
    begin
      respond_to do |format|
        if MiddleMan.worker(:manage_listings_worker).async_expire_stale_listings(:arg => nil)
          flash[:notice] = 'Run listing expiration function.'
          format.html { redirect_to admin_index_path }
          format.fbml { redirect_to admin_index_path }
          format.xml  { render :xml => :success }
        end
      end
    rescue Exception => e
      logger.error("Cannot refresh ferret index: #{e.message}")
    end
  end

  # Note: there is a conflict between Acts_as_ferret and  Acts_as_State_machine
  # not currently use, only here for demonstration purpose
  # Usage in a .erb file
  #      <%= link_to image_tag(RELOAD_BUTTON, {:title => "Reload search index", :alt => "Reload search index"}),
  #   reload_ferret_index_admin_path %> Reload search index<br/>
  def reload_ferret_index
    respond_to do |format|
      begin
        if MiddleMan.worker(:ferret_worker).async_rebuild_index()
          flash[:notice] = 'Search index will be rebuild.'
          format.html { redirect_to admin_index_path }
          format.fbml { redirect_to admin_index_path }
          format.xml  { render :xml => :success }
        end
      rescue Exception => e
        logger.error("Cannot refresh ferret index: #{e.message}")
      end
    end
  end
  
end


