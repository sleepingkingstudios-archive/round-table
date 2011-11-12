# spec/controllers/base_controller_spec.rb

require 'spec_helper'
require 'controllers/base_controller'

describe RoundTable::Controllers::BaseController do
  include RoundTable::Controllers
  
  before :each do
    module RoundTable::Mock
      module Controllers
        remove_const "MockController" if const_defined? "MockController"
        
        class MockController; end
      end # module Contexts
    end # module RoundTable::Mock
  end # before :each
  
  describe "#actions" do
    it "has a help action" do
      subject.has_action?(:help).should be true
    end # it has a help action
    
    it "has a what action that lists its available actions" do
      subject.has_action?(:what).should be true
      
      subject.class.instance_eval {
        action :foo do; end
        action :bar do; end
        action :baz do; end
      } # end class.instance_eval
      
      text_output = ""
      subject.add_listener :text_output, Proc.new { |event|
        text_output = event[:text]
      } # listener :text_output
      
      subject.execute_action :what
      
      subject.list_all_actions.each do |action|
        text_output.should =~ /#{action}/
      end # each
    end # it has a what action
  end # describe actions
end # describe BaseController
