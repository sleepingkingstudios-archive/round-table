# app/controllers/abstract_context.rb

require 'spec_helper'
require 'controllers/action_delegate_helper'
require 'controllers/abstract_controller'
require 'events/event_dispatcher'

describe RoundTable::Controllers::AbstractController do
  include RoundTable::Controllers
  include RoundTable::Events::EventDispatcher
  include RoundTable::Mock::Controllers
  
  before :each do
    module RoundTable::Mock
      module Controllers
        remove_const "MockController" if const_defined? "MockController"
        remove_const "AnotherMockController" if const_defined? "AnotherMockController"
        
        class MockController < RoundTable::Controllers::AbstractController; end
        class AnotherMockController < RoundTable::Controllers::AbstractController; end
      end # module Controllers
    end # module RoundTable::Mock
  end # before :each
  
  it_behaves_like "an ActionDelegate"
  
  it "should parse text input" do
    string = "verb verb_object preposition prep_object"
    subject.parse string
  end # it should parse text input
  
  it "can parse multi-word actions" do
    mock = double('callable')
    mock.should_receive(:look)
    mock.should_receive(:look_at)
    
    subject = MockController.new
    subject.class.instance_eval do
      action :look do |*args|
        mock.look
      end # action :look
      
      action :look_at do |*args|
        mock.look_at
      end # action :look
    end # class.instance_eval
    
    subject.parse("look")
    subject.parse("look at that")
  end # it can parse multi-word actions
  
  ####################
  # Context Stack-Tree
  
  it "should pass unknown actions to its parent controller" do
    mock_object = double('mock')
    mock_object.stub(:test) do |*args| end
    mock_object.should_receive(:test).with(:foo, :bar)
    
    parent = RoundTable::Mock::Controllers::MockController.new
    parent.class.instance_eval {
      action :do_something do |*args|
        mock_object.test(*args)
      end # action do_something
    } # end class.instance_eval
    
    child = AbstractController.new
    parent.add_child child
    
    child.execute_action :do_something, :foo, :bar
  end # it should pass ... to its parent ...
  
  it "if root controller, should send a text notice for unknown actions" do
    mock_object = double('mock')
    mock_object.should_receive(:print).with(/.+/)
    
    subject.add_listener :text_output, Proc.new { |event|
      mock_object.print event[:text]
    } # listener :text_output
    
    subject.execute_action :unknown_action
  end # it ... should send a text notice
  
  it "can list actions known to itself and its ancestors" do
    parent = RoundTable::Mock::Controllers::MockController.new
    parent.class.instance_eval {
      action :foo do; end
      action :bar do; end
    } # end class.instance_eval
    
    child = RoundTable::Mock::Controllers::AnotherMockController.new
    child.class.instance_eval {
      action :baz do; end
    } # end class.instance_eval
    
    parent.add_child child
    actions = child.list_all_actions
    %w(foo bar baz).each do |action|
      actions.should include action
    end # each
  end # it can list actions ...
  
  it "lists duplicate actions only once" do
    parent = RoundTable::Mock::Controllers::MockController.new
    parent.class.instance_eval {
      action :foo do; end
    } # end class.instance_eval
    
    child = RoundTable::Mock::Controllers::AnotherMockController.new
    child.class.instance_eval {
      action :foo do; end
    } # end class.instance_eval
    
    parent.add_child child
    child.list_all_actions.select { |item| item == "foo" }.count.should be 1
  end # it lists duplicate actions only once
end # describe RoundTable::Controllers::AbstractController
