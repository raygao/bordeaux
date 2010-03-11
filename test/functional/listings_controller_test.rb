require 'test_helper'
require File.dirname(__FILE__)+'/../../vendor/plugins/facebooker/lib/facebooker/rails/test_helpers.rb'

class ListingsControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  def test_should_get_index_for_facebook
    facebook_get :index
    assert_response :success
    assert_not_nil assigns(:listings)
  end

  def test_should_get_new_for_facebook
    facebook_get :new
    assert_response :success
  end

  def test_should_create_listing_for_facebook
    assert_difference('Listing.count') do
      facebook_post :create, :listing => { }
    end

    assert_facebook_redirect_to listing_path(assigns(:listing))
  end

  def test_should_show_listing_for_facebook
    facebook_get :show, :id => listings(:one).id
    assert_response :success
  end

  def test_should_get_edit_for_facebook
    facebook_get :edit, :id => listings(:one).id
    assert_response :success
  end

  def test_should_update_listing_for_facebook
    facebook_put :update, :id => listings(:one).id, :listing => { }
    assert_facebook_redirect_to listing_path(assigns(:listing))
  end

  def test_should_destroy_listing_for_facebook
    assert_difference('Listing.count', -1) do
      facebook_delete :destroy, :id => listings(:one).id
    end

    assert_facebook_redirect_to listings_path
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:listings)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_listing
    assert_difference('Listing.count') do
      post :create, :listing => { }
    end

    assert_redirected_to listing_path(assigns(:listing))
  end

  def test_should_show_listing
    get :show, :id => listings(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => listings(:one).id
    assert_response :success
  end

  def test_should_update_listing
    put :update, :id => listings(:one).id, :listing => { }
    assert_redirected_to listing_path(assigns(:listing))
  end

  def test_should_destroy_listing
    assert_difference('Listing.count', -1) do
      delete :destroy, :id => listings(:one).id
    end

    assert_redirected_to listings_path
  end
end
