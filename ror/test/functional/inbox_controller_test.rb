# -*- encoding : utf-8 -*-
require 'test_helper'

class InboxControllerTest < ActionController::TestCase
  test "should get infoindex" do
    get :infoindex
    assert_response :success
  end

end
