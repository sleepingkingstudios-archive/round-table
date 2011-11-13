# spec/controllers/base_controller_spec.rb

require 'spec_helper'
require 'controllers/base_controller'

module RoundTable::Mock
  module Controllers; end
end # module RoundTable::Mock

describe RoundTable::Controllers::BaseController do
  include RoundTable::Controllers
  include RoundTable::Mock::Controllers
  
  def clear_mock
    RoundTable::Mock::Controllers.module_eval do
      remove_const :MockController if const_defined? :MockController
    end # module_eval
  end # function clear_mock
  
  def define_mock(base_class)
    clear_mock
    
    RoundTable::Mock::Controllers.module_eval do
      klass = Class.new base_class
      const_set :MockController, klass
    end # module_eval
  end # function define_mock
  
  before :each do
    define_mock(described_class)
  end # before :each
  
  after :each do
    clear_mock
  end # after :each
  
  subject { MockController.new }
  
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
