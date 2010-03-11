#!/bin/sh
export PATH=/usr/bin:$PATH
rake tunnlr:start &
script/server -p 8888 -e development

################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################