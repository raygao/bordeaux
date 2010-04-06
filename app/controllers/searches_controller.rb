################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class SearchesController < ApplicationController
  # GET /searches
  # GET /searches.xml

  def index
    @search = Search.new

    respond_to do |format|
      format.html # new.html.erb
      format.fbml # new.fbml.erb
      format.xml  { render :xml => @search }
    end
  end


  # GET /searches/1
  # GET /searches/1.xml
  def show
    @search = Search.find(params[:id])
    render :text => "show method called."

    respond_to do |format|
      format.html # show.html.erb
      format.fbml # show.fbml.erb
      format.xml  { render :xml => @search }
    end
  end

  # GET /searches/new
  # GET /searches/new.xml
  def new
    @search = Search.new

    respond_to do |format|
      format.html # new.html.erb
      format.fbml # new.fbml.erb
      format.xml  { render :xml => @search }
    end
  end

  def dosearch
    #TODO show only active, not inactive, or deleted
    @search_type = params[:search][:search_type]
    if (params[:search][:item_status].nil?)
      @item_status = 'public'
    else
      @item_status = params[:search][:item_status]
    end
    case @search_type
    when 'query'
      begin
        @query = params[:search][:query]

        # Use Rails' default search, 'acts_as_ferret' does not catch changes made
        # by 'acts_as_state_machine'
        @_listings = Listing.find_all_by_status(@item_status, :conditions=>
            ["title like :search OR description like :search",
            {:search => "%" +  @query + "%"}]
        )

        # See following for documentations:
        # Will Paginate home - http://gitrdoc.com/mislav/will_paginate/tree/master/
        # (removed) Acts as Ferret api doc - http://projects.jkraemer.net/rdoc/acts_as_ferret/
        # Ferret tutorial - http://ferret.davebalmain.com/api/files/TUTORIAL.html
        # as well as issue with 'total_pages' problem
        # <%= will_paginate(@listings, :params => { 'search[query]' => @query,
        #    'search[search_type]' => @search_type} )%>

        # use Listing.rebuild_index     to rebuild the index of ferret

        # only return results that is in Public State and matches either Description or Title
        # query = "status:'public' AND description:#{@query} OR title:#{@query}"
        # @_listings = Listing.find_with_ferret(query)
        
        @listings = @_listings.paginate :page => params[:page], :per_page => LISTING_PER_PAGE
        logger.info "Number of matches: " + @listings.size.to_s
      end
    when 'category_id'
      begin
        @category_id = params[:search][:category_id]
        # Use Rails' default search, not as fast.
        @_listings = Listing.find_all_by_category_id(@category_id)
        #@_listings = Listing.find_all_by_category_id(@category_id, :conditions=>
        #    ["status = :status", {:status => 'public|private'}])

        # Using Acts_as_ferret
        # query = "category_id:#{@category_id}"
        # @listings = Listing.find_with_ferret(query) .paginate :page => params[:page], :per_page => LISTING_PER_PAGE

        @listings = @_listings.paginate :page => params[:page], :per_page => LISTING_PER_PAGE
      end
    else #default to 'query' search, TODO need to merge with above into a common method
      begin
        @query = params[:search][:query]

        # Use Rails' default search, 'acts_as_ferret' does not catch changes made
        # by 'acts_as_state_machine'
        @_listings = Listing.find_all_by_status(@item_status, :conditions=>
            ["title like :search OR description like :search",
            {:search => "%" +  @query + "%"}]
        )

        # See following for documentations (
        # Will Paginate home - http://gitrdoc.com/mislav/will_paginate/tree/master/
        # Acts as Ferret api doc - http://projects.jkraemer.net/rdoc/acts_as_ferret/
        # Ferret tutorial - http://ferret.davebalmain.com/api/files/TUTORIAL.html
        # as well as issue with 'total_pages' problem

        # use Listing.rebuild_index     to rebuild the index of ferret

        # only return results that is in Public State and matches either Description or Title
        # query = "status:'public' AND description:#{@query} OR title:#{@query}"
        # @_listings = Listing.find_with_ferret(query)

        @listings = @_listings.paginate :page => params[:page], :per_page => LISTING_PER_PAGE
        logger.info "Number of matches: " + @listings.size.to_s
      end
    end

    respond_to do |format|
      remove_fb_sig_friends_from_params # See Application_controller for explaination.
      format.html # doserach.html.erb
      format.fbml # dosearch.fbml.erb
      format.xml  { render :xml => @listings }
    end

  end

end