################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class UserMailer < ActionMailer::Base

  # See corresponding files in view/user_mailer directory
  # Do not add _mail to the end of the method name, it causes a problem with the backgroundrb's parsing!
  # It is caused by the parsing of the method_missing!
  def approval(recipient, listing_title, listing_id)
    subject    "Your listing \'#{listing_title}\' has been approved."
    recipients recipient
    from       'appfactory <appfactory@appfactory.us>'
    sent_on    Time.now
    body       :url => FB_APP_HOME_URL, :listing_title => listing_title, :listing_id => listing_id
  end

  # Do not add _mail to the end of the method name, it causes a problem with the backgroundrb's parsing!
  # It is caused by the parsing of the method_missing!
  def rejection(recipient, listing_title, listing_id)
    subject    "Your listing \'#{listing_title}\' has been reject. Please edit and resubmitted."
    recipients recipient
    from       'appfactory <appfactory@appfactory.us>'
    sent_on    Time.now
    body       :url => FB_APP_HOME_URL, :listing_title => listing_title, :listing_id => listing_id
  end

  # Do not add _mail to the end of the method name, it causes a problem with the backgroundrb's parsing!
  # It is caused by the parsing of the method_missing!
  def test(recipient)
    subject    'This is a test mail for you.'
    recipients recipient
    from       'appfactory <appfactory@appfactory.us>'
    sent_on    Time.now
    body       :email => recipient, :url => FB_APP_HOME_URL
  end

end
