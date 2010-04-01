################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

logger = RAILS_DEFAULT_LOGGER
logger.info  "***Loading constants.rb file***"

#Rails launching environment, e.g. DB, port number, etc.
# TODO for easy setup, move all .yml files to database for security and management.
# also, see 'configuration/environments/development.rb, production.rb, and test.rb'

# For date format, see environment.rb
# 
#Facebook group id & name, e.g. porch
# get_group_name(gid) should automatically return the group name, if not found
# then use the group name from below.
FACEBOOK_GROUP_NAME = "The Porch at Watermark"

#FACEBOOK_GROUP_ID = "2239895265" #porch
FACEBOOK_GROUP_ID = '317540568227' #project_bordeaux_group

#Pagination per page
LISTING_PER_PAGE = 10
#EULA file
EULA_FILE = 'eula.html'

#MouseOver Color
MOUSE_OVER_COLOR = '#FFCC00'
#MouseOut Color
MOUSE_OUT_COLOR = '#ffffff'

#Time between cleaning session variables, e.g. checking for admin status
#in seconds,, 3600 seconds equals 1 hours, every hour, it checks for that if a
#person is the admin of a group.
MAX_SESSION_PERIOD = 3600
# if SUPER_USER_ID is set to 0, then everyone is an admin in the application.
#SUPER_USER_ID = 0
SUPER_USER_ID = 1377516720

# Time to expire old listings
LISTING_LIFE_SPAN = 30 # <number of days>

##############################################################################
# State of a lisiting, see Acts_as_state_machine
# 'public', 'private', 'expired', 'pending', 'rejected'
# see Listing.rb file
##############################################################################

###############################################################################
# buttons & images
###############################################################################
GROUP_LOGO = "bordeaux.jpg"

ACCEPT_BUTTON = "check_36x36.png"
ADD_BUTTON = "add_36x36.png"
ADMIN_MAIN_BUTTON = 'admin_main_36x36.png'
APPROVE_BUTTON = 'approve_36x36.png'
CANCEL_BUTTON = "cancel_36x36.png"
CALENDAR_ICON = 'calendar_36x36.png'
DELETE_BUTTON = "delete_36x36.png"
DELETE_CATEGORY_BUTTON = "delete_category_36x36.png"
DOWNLOAD_ICON = 'download_36x36.png'
EDIT_BUTTON = "edit_36x36.png"
EMAIL_BUTTON = "email_36x36.png"
EXPORT_EXCEL_BUTTON = "export_excel_file_36x36.png"
GROUP_ICON = 'group_admin_36x36.png'
INVITE_BUTTON = "invite_icon_36x36.jpg"
MANAGE_CATEGORY_BUTTON = 'category_36x36.png'
NEW_CATEGORY_BUTTON = "new_category_36x36.png"
NEW_LISTING_BUTTON = "new_36x36.png"
NEWS_ICON = "web_news_icon_36x36.jpg"
PERMIT_ICON = 'permit_36x36.png'
PLAY_BUTTON = "play_36x36.png"
RELOAD_BUTTON = "reload_36x36.png"
RENAME_BUTTON = "rename_36x36.png"
REPLAY_BUTTON = "replay_36x36.png"
REJECTED_ICON = "rejected_36x36.png"
RETURN_ICON = 'left_arrow_36x36.png'
REMOVE_EMAIL_ICON = 'remove_email_36x36.png'
SEARCH_BUTTON = "search_36x36.png"
STOP_BUTTON = "stop_36x36.png"
SHOW_ALL_LISTINGS_BUTTON = "show_all_listings_36x36.png"
SHOW_MY_LISTINGS_BUTTON = "show_my_listings_36x36.png"
STALE_ICON = "blue_cheese_36x36.png"
TALK_ICON = "talk_36x36.png"
UPLOAD_BUTTON = "upload_36x36.png"
VIEW_BUTTON = "eye_36x36.png"
WAIT_ICON = 'wait_36x36.png'

###############################################################################
# Miscallaneous stuff
###############################################################################
#Oodle keys
MAX_SEARCH_NUMBER = 15 #Odle max search
OODLE_KEY = 'C96F172D2EA4'

