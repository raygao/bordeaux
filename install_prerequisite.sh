#!/bin/bash
export PATH=/usr/bin:$PATH
sudo /usr/bin/gem install mongrel json net-ssh ferret acts_as_ferret will_paginate RedCloth
sudo /usr/bin/gem install spreadsheet ruby-ole chronic packet acts_as_state_machine SystemTimer
# Rail 2.3.5 is not compatiable with Passenger as of yet.
#sudo /usr/bin/gem install passenger
#sudo passenger-install-apache2-module

################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################
