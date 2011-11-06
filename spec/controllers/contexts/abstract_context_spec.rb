# app/controllers/contexts/abstract_context.rb

require 'spec_helper'
require 'controllers/contexts/abstract_context'
require 'events/event_dispatcher'

module RoundTable::Mock
  module Controllers
    module Contexts
      class MockContext < RoundTable::Controllers::Contexts::AbstractContext
        
      end # class MockContext
    end # module Contexts
  end # module Controllers
end # module RoundTable::Mock

describe RoundTable::Controllers::Contexts::AbstractContext do
  include RoundTable::Controllers::Contexts
  include RoundTable::Events::EventDispatcher
  include RoundTable::Mock::Controllers::Contexts
  
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
    
    parent = MockContext.new
    parent.class.instance_eval {
      action :do_something do |*args|
        mock_object.test(*args)
      end # action do_something
    } # end class.instance_eval
    
    child = AbstractContext.new
    parent.add_child child
    
    child.execute_action :do_something, :foo, :bar
  end # it should pass ... to its parent ...
end # describe RoundTable::Controllers::Contexts::AbstractContext
