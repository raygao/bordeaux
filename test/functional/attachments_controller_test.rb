require 'test_helper'
require File.dirname(__FILE__)+'/../../vendor/plugins/facebooker/lib/facebooker/rails/test_helpers.rb'

class AttachmentsControllerTest < ActionController::TestCase
  include Facebooker::Rails::TestHelpers
  def test_should_get_index_for_facebook
    facebook_get :index
    assert_response :success
    assert_not_nil assigns(:attachment)
  end

  def test_should_get_new_for_facebook
    facebook_get :new
    assert_response :success
  end

  def test_should_create_attachment_for_facebook
    assert_difference('Attachment.count') do
      facebook_post :create, :attachment => { }
    end

    assert_facebook_redirect_to attachment_path(assigns(:attachment))
  end

  def test_should_show_attachment_for_facebook
    facebook_get :show, :id => attachment(:one).id
    assert_response :success
  end

  def test_should_get_edit_for_facebook
    facebook_get :edit, :id => attachment(:one).id
    assert_response :success
  end

  def test_should_update_attachment_for_facebook
    facebook_put :update, :id => attachment(:one).id, :attachment => { }
    assert_facebook_redirect_to attachment_path(assigns(:attachment))
  end

  def test_should_destroy_attachment_for_facebook
    assert_difference('Attachment.count', -1) do
      facebook_delete :destroy, :id => attachment(:one).id
    end

    assert_facebook_redirect_to attachment_path
  end

  def test_should_get_index
    get :index
    assert_response :success
    assert_not_nil assigns(:attachment)
  end

  def test_should_get_new
    get :new
    assert_response :success
  end

  def test_should_create_attachment
    assert_difference('Attachment.count') do
      post :create, :attachment => { }
    end

    assert_redirected_to attachment_path(assigns(:attachment))
  end

  def test_should_show_attachment
    get :show, :id => attachment(:one).id
    assert_response :success
  end

  def test_should_get_edit
    get :edit, :id => attachment(:one).id
    assert_response :success
  end

  def test_should_update_attachment
    put :update, :id => attachment(:one).id, :attachment => { }
    assert_redirected_to attachment_path(assigns(:attachment))
  end

  def test_should_destroy_attachment
    assert_difference('Attachment.count', -1) do
      delete :destroy, :id => attachment(:one).id
    end

    assert_redirected_to attachment_path
  end
end
