require 'test_helper'
require File.dirname(__FILE__)+'/../../vendor/plugins/facebooker/lib/facebooker/rails/test_helpers.rb'

class DiscussionsControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  def test_should_get_index_for_facebook
    facebook_get :index
    assert_response :success
    assert_not_nil assigns(:discussions)
  end

  def test_should_get_new_for_facebook
    facebook_get :new
    assert_response :success
  end

  def test_should_create_discussion_for_facebook
    assert_difference('Discussion.count') do
      facebook_post :create, :discussion => { }
    end

    assert_facebook_redirect_to discussion_path(assigns(:discussion))
  end

  def test_should_show_discussion_for_facebook
    facebook_get :show, :id => discussions(:one).id
    assert_response :success
  end

  def test_should_get_edit_for_facebook
    facebook_get :edit, :id => discussions(:one).id
    assert_response :success
  end

  def test_should_update_discussion_for_facebook
    facebook_put :update, :id => discussions(:one).id, :discussion => { }
    assert_facebook_redirect_to discussion_path(assigns(:discussion))
  end

  def test_should_destroy_discussion_for_facebook
    assert_difference('Discussion.count', -1) do
      facebook_delete :destroy, :id => discussions(:one).id
    end

    assert_facebook_redirect_to discussions_path
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:discussions)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_discussion
    assert_difference('Discussion.count') do
      post :create, :discussion => { }
    end

    assert_redirected_to discussion_path(assigns(:discussion))
  end

  def test_should_show_discussion
    get :show, :id => discussions(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => discussions(:one).id
    assert_response :success
  end

  def test_should_update_discussion
    put :update, :id => discussions(:one).id, :discussion => { }
    assert_redirected_to discussion_path(assigns(:discussion))
  end

  def test_should_destroy_discussion
    assert_difference('Discussion.count', -1) do
      delete :destroy, :id => discussions(:one).id
    end

    assert_redirected_to discussions_path
  end
end
