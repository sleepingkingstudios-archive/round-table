# app/controllers/contexts/abstract_context.rb

require 'spec_helper'
require 'controllers/contexts/abstract_context'
require 'events/event_dispatcher'

describe RoundTable::Controllers::Contexts::AbstractContext do
  include RoundTable::Controllers::Contexts
  include RoundTable::Events::EventDispatcher
  
  before :each do
    module RoundTable::Mock
      module Controllers
        module Contexts
          remove_const "MockContext" if const_defined? "MockContext"
          remove_const "AnotherMockContext" if const_defined? "AnotherMockContext"
          
          class MockContext < RoundTable::Controllers::Contexts::AbstractContext; end
          class AnotherMockContext < RoundTable::Controllers::Contexts::AbstractContext; end
        end # module Contexts
      end # module Controllers
    end # module RoundTable::Mock
  end # before :each
  
  it "should parse text input" do
    string = "verb verb_object preposition prep_object"
    subject.parse string
  end # it should parse text input
  
  ####################
  # Context Stack-Tree
  
  it "if root context, should send a text notice for unknown actions" do
    mock_object = double('mock')
    mock_object.should_receive(:print).with(/.+/)
    
    subject.add_listener :text_output, Proc.new { |event|
      mock_object.print event[:text]
    } # listener :text_output
    
    subject.execute_action :unknown_action
  end # it ... should send a text notice
  
  it "should pass unknown actions to its parent context" do
    mock_object = double('mock')
    mock_object.stub(:test) do |*args| end
    mock_object.should_receive(:test).with(:foo, :bar)
    
    parent = RoundTable::Mock::Controllers::Contexts::MockContext.new
    parent.class.instance_eval {
      action :do_something do |*args|
        mock_object.test(*args)
      end # action do_something
    } # end class.instance_eval
    
    child = AbstractContext.new
    parent.add_child child
    
    child.execute_action :do_something, :foo, :bar
  end # it should pass ... to its parent ...
  
  it "can list actions known to itself and its ancestors" do
    parent = RoundTable::Mock::Controllers::Contexts::MockContext.new
    parent.class.instance_eval {
      action :foo do; end
      action :bar do; end
    } # end class.instance_eval
    
    child = RoundTable::Mock::Controllers::Contexts::AnotherMockContext.new
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
    parent = RoundTable::Mock::Controllers::Contexts::MockContext.new
    parent.class.instance_eval {
      action :foo do; end
    } # end class.instance_eval
    
    child = RoundTable::Mock::Controllers::Contexts::AnotherMockContext.new
    child.class.instance_eval {
      action :foo do; end
    } # end class.instance_eval
    
    parent.add_child child
    child.list_all_actions.select { |item| item == "foo" }.count.should be 1
  end # it lists duplicate actions only once
end # describe RoundTable::Controllers::Contexts::AbstractContext
