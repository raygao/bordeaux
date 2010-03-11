################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

ActionController::Routing::Routes.draw do |map|
  map.resources :attachments,
    :member => {:download => [:get, :put]}

  map.resources :events

  map.resources :events,
    :member => {
    :create_fb => [:get, :put]
  }

  map.resources :categories do |category|
    category.resources :listings
  end

  map.resources :photos

  map.resources :admin, :collection => {
    :reload_ferret_index => [:get, :put],
    :group_info => [:get, :put],
    :expire_stale_listings => [:get, :put]
  }

  map.resources :searches, :collection => { :dosearch => [:get, :put]  }

  map.resources :listings, :collection => {
    :show_submitted => [:get, :put],
    :approve => [:get, :put],
    :reject => [:get, :put],
    :new2 => [:get, :put]
  }

  map.resources :home, :except => [:destroy, :edit, :new]
    
  map.resources :util, :collection  => { :show_disclaimer => [:get, :put],
    :set_eula_status => [:get, :put],
    :invite => [:get, :post],
    :generate_export_url => [:get, :post],
    :do_export => [:get, :post],
    :confirmed => [:get, :post],
    :welcome => [:get, :post],
    :news => [:get, :post],
    :get_fb_email_address => [:get, :put],
    :group_info => [:get, :put],
    :privacy => [:get, :put],
    :tos => [:get, :put],
    :help => [:get, :put],
    :about => [:get, :put],
    :set_fb_permission => [:get, :put]
  },
    :member => {
    :notify_user => [:get, :put]
  }
  
  map.root :controller => "home", :action => "index", :format => 'fbml'

  map.connect ':controller/:action'
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'

  map.connect '//', :controller => 'home', :format => 'fbml'
  map.connect '//home', :controller => 'home', :format => 'fbml'

  map.connect '//listings', :controller => 'listings', :format => 'fbml'
  map.connect '//util/do_export', :controller => 'util', :action => 'do_export'

  map.connect '/privacy', :controller => 'util', :action => 'privacy'
  map.connect '/tos', :controller => 'util', :action => 'tos'
  map.connect '/help', :controller => 'util', :action => 'help'
  map.connect '/about', :controller => 'util', :action => 'about'

  # Problem: http://web1.tunnlr.com:10337//?auth_token=fff4cb45e5f34e7eb76a40f7f5dee28f
  #map.connect '//?auth_token', :controller => 'home', :action => 'index'

end