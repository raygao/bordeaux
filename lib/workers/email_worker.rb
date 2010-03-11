################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

class EmailWorker < BackgrounDRb::MetaWorker
  set_worker_name :email_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    puts "*** email_worker: Create method. ***"
    logger.info "*** email_worker: Create method. ***"
  end


  # See: regarding to pass multiple arguments, http://www.mail-archive.com/backgroundrb-devel@rubyforge.org/msg00971.html
  # Note: hash key does not work, it is a documented bug in 'backgroundrb'. Must use array
  # call using MiddleMan.worker(:email_worker).async_send_rejection_mail(:arg => ['email_address', 'listing_title', listing_id#])
  def send_rejection_mail(args)
    begin
      recipient = args[0]
      listing_title = args[1]
      listing_id = args[2]
      result = UserMailer.deliver_rejection(recipient, listing_title, listing_id)
      puts "*** Email_worker: Sent listing rejection email ***"
      logger.info "*** Email_worker: Sent listing rejection email ***"
      return result
    rescue Exception => e
      logger.error("###Email_worker: An exception occurred in sending email to #{recipient}. type: #{e.class}, message: #{e.to_s}")
    end
  end

  # See: regarding to pass multiple arguments, http://www.mail-archive.com/backgroundrb-devel@rubyforge.org/msg00971.html
  # Note: hash key does not work, it is a documented bug in 'backgroundrb'. Must use array
  # call using MiddleMan.worker(:email_worker).async_send_approval_mail(:arg => ['email_address', 'listing_title', listing_id#])
  def send_approval_mail(args)
    begin
      recipient = args[0]
      listing_title = args[1]
      listing_id = args[2]
      result = UserMailer.deliver_approval(recipient, listing_title, listing_id)
      puts "*** Email_worker: Sent listing approval email ***"
      logger.info "*** Email_worker: Sent listing approval email ***"
      return result
    rescue Exception => e
      logger.error("###Email_worker: An exception occurred in sending email to #{recipient}. type: #{e.class}, message: #{e.to_s}")
    end
  end

  #Format for calling middleman:
  #MiddleMan.worker(:email_worker).async_test_blank_mail(:arg => [recipient])
  def send_test_mail(recipient)
    begin
      result = UserMailer.deliver_test(recipient)
      result = UserMailer.deliver_approval(recipient)
      puts "*** Email_worker: Sent test email to #{recipient}***"
      logger.info "*** Email_worker: Sent test email to #{recipient}***"
      return result
    rescue Exception => e
      logger.error("###Email_worker: An exception occurred in sending email to #{recipient}. type: #{e.class}, message: #{e.to_s}")
    end
  end

end

