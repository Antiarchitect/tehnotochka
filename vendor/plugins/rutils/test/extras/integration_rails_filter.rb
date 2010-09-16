# -*- encoding: utf-8 -*- 
require 'action_controller'
require 'action_controller/test_process'
require File.dirname(__FILE__) +  '/../../init.rb'

ActionController::Routing::Routes.draw {  |map| map.connect ':controller/:action/:id' }

class RutiledController < ActionController::Base #:nodoc:
  def overridden
    raise "Overrides are off" unless RuTils::overrides_enabled?
    render :inline => '<%= Time.local(2008,8,8).strftime("%B") %>'
  end
  def rescue_action(e); raise e; end
end

# Перегрузка helper'ов Rails
rails_test_class = defined?(ActionController::TestCase) ? ActionController::TestCase : Test::Unit::TestCase

class RailsFilterTest < rails_test_class
  
  if respond_to?(:tests) # Еще одно изобретение чтобы как можно больше вещей были несовместимы от рельсов к рельсам 
    tests RutiledController
  end
  
  def setup
    @controller = RutiledController.new
    @request = ActionController::TestRequest.new
    @response = ActionController::TestResponse.new
  end
  
  def test_overrides_preserved_in_render
    assert_nothing_raised { get :overridden }
    assert_response :success
    assert_equal "август", @response.body
  end
end