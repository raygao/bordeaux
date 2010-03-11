require 'test_helper'

class UserMailerTest < ActionMailer::TestCase
  test "notify_approval" do
    @expected.subject = 'UserMailer#notify_approval'
    @expected.body    = read_fixture('notify_approval')
    @expected.date    = Time.now

    assert_equal @expected.encoded, UserMailer.create_notify_approval(@expected.date).encoded
  end

end
