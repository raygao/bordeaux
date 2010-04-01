################################################################################
# Project Bordeaux: A simple Facebook Content Management System                #
# Copyright © 2010 Raymond Gao / http://Appfactory.Are4.us                     #
################################################################################

require RAILS_ROOT + "/config/constants"

class Listing < ActiveRecord::Base
  # Not using Acts_as_ferret, because it conflicts with acts_as_state_machine
  # Acts_as_ferret does not update state changes caused by Acts_as_state_machine.
  # Consequently, it breaks.
  # acts_as_ferret :fields => [:title, :description, :user_id, :category_id, :status]

  belongs_to  :category
  belongs_to  :user
  belongs_to  :state

  #removes both photos and events associated with this listing, what's on facebook remains there.
  has_many    :photos, :dependent => :destroy
  has_many    :attachments, :dependent => :destroy
  has_many    :events, :dependent => :destroy

  acts_as_state_machine :initial => :pending, :column => 'status'

  #see RAILS_ROOT + "/config/constants.rb file"
  state :public, :after => :inform_user_approval
  state :private
  state :expired
  state :pending  # initial state
  state :rejected, :after => :inform_user_rejection

  event :approve do
    transitions :from => :pending,  :to => :public
  end

  event :reject do
    transitions :from => :pending,  :to => :rejected
  end

  event :expire do
    transitions :from => [:public, :private, :pending, :rejected], :to => :expired
  end

  event :make_private do
    transitions :from => :public,  :to => :private
  end

  event :make_public do
    transitions :from => :private,  :to => :public
  end

  def inform_user_approval
    logger.info "***Listing.rb: Sending Approved notice to the user.***"
    # using backgroundrb to send approval email
  end

  def inform_user_rejection
    logger.info "***Listing.rb: Sending rejection notice to the user.***"
    # using backgroundrb to send rejection email
  end

end