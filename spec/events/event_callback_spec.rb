# spec/events/event_callback_spec.rb

require 'spec_helper'
require 'events/event'
require 'events/event_callback'

describe RoundTable::Events::EventCallback do
  include RoundTable::Events
  
  before :each do
    @callback = double('mock_callable')
    @callback.stub(:call)
    
    @event = Event.new :test_event
  end # before :each
  
  it "takes a callable parameter" do
    expect { EventCallback.new }.to raise_error ArgumentError
    expect { EventCallback.new nil }.to raise_error ArgumentError
    expect { EventCallback.new :symbol }.to raise_error ArgumentError
    expect { EventCallback.new "string" }.to raise_error ArgumentError
    
    EventCallback.new @callback
  end # it takes a callable parameter
  
  it "should only be equal if it has the same callback and priority" do
    subject = EventCallback.new @callback
    subject.should eq(EventCallback.new @callback)
    
    other_callback = double('mock_callable')
    other_callback.stub(:call)
    
    subject.should_not eq(EventCallback.new other_callback)
    subject.should_not eq(EventCallback.new @callback, :priority => :first)
  end # it should only be equal if it is the same object
  
  it "can be called taking an event object" do
    @callback.should_receive(:call)
    
    subject = EventCallback.new @callback
    expect { subject.call }.to raise_error ArgumentError
    expect { subject.call nil }.to raise_error ArgumentError
    expect { subject.call :symbol }.to raise_error ArgumentError
    expect { subject.call "string" }.to raise_error ArgumentError
    
    subject.call @event
  end # it can be called
  
  it "has a callback" do
    subject = EventCallback.new @callback
    subject.callback.should eq(@callback)
  end # it has a callback
  
  it "has a priority" do
    subject = EventCallback.new @callback
    subject.priority.should be 0
    
    subject = EventCallback.new @callback, :priority => 5
    subject.priority.should be 5
    
    subject = EventCallback.new @callback, :priority => :first
    subject.priority.should be :first
    
    subject = EventCallback.new @callback, :priority => :last
    subject.priority.should be :last
    
    subject = EventCallback.new @callback, :priority => nil
    subject.priority.should be 0
    
    subject = EventCallback.new @callback, :priority => :foo
    subject.priority.should be 0
  end # it has a priority
  
  it "can be sorted by priority" do
    first = EventCallback.new @callback, :priority => :first
    zero  = EventCallback.new @callback, :priority => 0
    one   = EventCallback.new @callback, :priority => 1
    two   = EventCallback.new @callback, :priority => 2
    last  = EventCallback.new @callback, :priority => :last
    
    callbacks = [one, two, zero, last, first]
    callbacks.sort# .should eq([first, zero, one, two, last])
  end # it can be sorted by priority
  
  it "has custom data" do
    subject = EventCallback.new @callback, :priority => 7, :foo => "bar"
    subject.data[:priority].should be nil
    subject.data[:foo].should == "bar"
    
    subject.data[:baz] = "bizzle"
    subject.data[:baz].should == "bizzle"
  end # it has custom data
end # describe EventCallback
