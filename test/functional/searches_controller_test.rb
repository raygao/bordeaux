require 'test_helper'
require File.dirname(__FILE__)+'/../../vendor/plugins/facebooker/lib/facebooker/rails/test_helpers.rb'

class SearchesControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  def test_should_get_index_for_facebook
    facebook_get :index
    assert_response :success
    assert_not_nil assigns(:searches)
  end

  def test_should_get_new_for_facebook
    facebook_get :new
    assert_response :success
  end

  def test_should_create_search_for_facebook
    assert_difference('Search.count') do
      facebook_post :create, :search => { }
    end

    assert_facebook_redirect_to search_path(assigns(:search))
  end

  def test_should_show_search_for_facebook
    facebook_get :show, :id => searches(:one).id
    assert_response :success
  end

  def test_should_get_edit_for_facebook
    facebook_get :edit, :id => searches(:one).id
    assert_response :success
  end

  def test_should_update_search_for_facebook
    facebook_put :update, :id => searches(:one).id, :search => { }
    assert_facebook_redirect_to search_path(assigns(:search))
  end

  def test_should_destroy_search_for_facebook
    assert_difference('Search.count', -1) do
      facebook_delete :destroy, :id => searches(:one).id
    end

    assert_facebook_redirect_to searches_path
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:searches)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_search
    assert_difference('Search.count') do
      post :create, :search => { }
    end

    assert_redirected_to search_path(assigns(:search))
  end

  def test_should_show_search
    get :show, :id => searches(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => searches(:one).id
    assert_response :success
  end

  def test_should_update_search
    put :update, :id => searches(:one).id, :search => { }
    assert_redirected_to search_path(assigns(:search))
  end

  def test_should_destroy_search
    assert_difference('Search.count', -1) do
      delete :destroy, :id => searches(:one).id
    end

    assert_redirected_to searches_path
  end
end
