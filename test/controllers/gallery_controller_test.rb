require 'test_helper'

class GalleryControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

  test "should get albums" do
    get :albums
    assert_response :success
  end

  test "should get images" do
    get :images
    assert_response :success
  end

end
