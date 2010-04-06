################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class HomeController < ApplicationController

  def index
    # redirect from http://web1.tunnlr.com:10337//?auth_token=a20623b3daf11dc9fd216672cafdf162
    # to regular page, see Application_controller and configuration/development,
    # production, test.rb files
    if (request.parameters["fb_sig_user"].nil?)
      # This addresses the app login problem, previously it was directed to index.html.erb
      # previously, it was directed to http://web1.tunnlr.com:10337//?auth_token=9ab1b965ac6337d34dbb135927d54767
      # now, it gets redirect to "http://apps.facebook.com/bordeaux",
      # see configuration/environments/development.rb, production.rb, and test.rb files
      route_to_home

    else
      if params[:user_id]
        # find listings with userid
        @user = User.find(params[:user_id])
      else
        @user = current_user
        # classic way of finding friends, replaced by @list_of_friends
        #@user_s_friends = (params[:fb_sig_friends]||"").split(/,/)
        @list_of_friends = facebook_session.user.friends
        @user_fb_id = @user['facebook_id']

        #show most recent listings
        # Use Rails' default search, 'acts_as_ferret' does not catch changes made
        # by 'acts_as_state_machine'
        @listings = Listing.find_all_by_status('public', :order => "created_at DESC").paginate :page => params[:page], :per_page => LISTING_PER_PAGE
      end

      respond_to do |format|
        remove_fb_sig_friends_from_params
        format.html # index.html.erb
        format.fbml # index.fbml.erb
        format.xml  #{ render :xml => @listings }
      end
      
    end
  end
  
end