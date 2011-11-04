# spec/events/event_spec.rb

require 'spec_helper'
require 'events/event.rb'

describe RoundTable::Events::Event do
  include RoundTable::Events
  
  it "should have an immutable type" do
    expect { Event.new }.to raise_error ArgumentError
    
    type = :text_event
    subject = Event.new type
    subject.type.should eq(type)
    
    expect { subject.type = :test }.to raise_error
  end # it should have a type
  
  it "can save arbitrary data" do
    subject = Event.new :data_event, :foo => "bar"
    subject[:foo].should eq("bar")
    
    subject[:baz] = "bizzle"
    subject[:baz].should eq("bizzle")
  end # it can save arbitrary data
end # describe Event
