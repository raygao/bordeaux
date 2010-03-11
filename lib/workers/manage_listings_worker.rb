################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

require RAILS_ROOT + '/lib/constants'

class ManageListingsWorker < BackgrounDRb::MetaWorker
  set_worker_name :manage_listings_worker
  def create(args = nil)
    add_periodic_timer(21600) {expire_stale_listings} # expire listing every 6 hours
    # this method is called, when worker is loaded for the first time
    puts "*** Manage_listing_worker: manage_listing_worker: Create method. ***"
    logger.info "*** Manage_listing_worker: manage_listing_worker: Create method. ***"
  end

  def expire_stale_listings
    puts "*** Manage_listing_worker: starting to expire stale listings ***"
    logger.info "*** Manage_listing_worker: starting to expire stale listings ***"
    # TODO set up a schedule that runs every night
    expire_date = DateTime.now - LISTING_LIFE_SPAN.days
    @stale_listings = Listing.find(:all, :conditions=>
            ["updated_at < :expire_date AND status NOT LIKE :status",
            {:expire_date => expire_date, :status => "expired"}]
        )

    for listing in @stale_listings
      if !listing.expired?
        listing.expire!
        puts "*** Manage_listing_worker: Expired #{listing.title}. ***"
        logger.info "*** Manage_listing_worker: Expired #{listing.title}. ***"
      end
    end

    puts "*** Manage_listing_worker: The group administrator has expired #{@stale_listings.size} listings on #{DateTime.now}. ***"
    logger.info "*** Manage_listing_worker: The group administrator has expired #{@stale_listings.size} listings on #{DateTime.now}. ***"
  end

end
