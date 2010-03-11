################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

#see http://github.com/jkraemer/acts_as_ferret
require 'acts_as_ferret'

require RAILS_ROOT + '/lib/constants'

# see http://www.mail-archive.com/backgroundrb-devel@rubyforge.org/msg00807.html
# about the issue: No such file or directory - packet_worker_runner
# must do /usr/bin/gem install chronic packet

class FerretWorker < BackgrounDRb::MetaWorker
  set_worker_name :ferret_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    add_periodic_timer(3600) {rebuild_index} #rebuild every hour
    puts "*** Ferret_worker: Create method. ***"
    logger.info "*** Ferret_worker: Create method. ***"
  end

  def rebuild_index
    puts "*** Ferret_worker: Refreshing ferret index for the model <Listing>. ***"
    logger.info "*** Ferret_worker: Refreshing ferret index for the model <Listing>. ***"
    return Listing.rebuild_index
  end
end