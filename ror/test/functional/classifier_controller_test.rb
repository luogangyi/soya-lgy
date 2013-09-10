# -*- encoding : utf-8 -*-
require 'test_helper'

class ClassifierControllerTest < ActionController::TestCase
  test "should get classify" do
    get :classify
    assert_response :success
  end

end
