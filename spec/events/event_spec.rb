# spec/events/event_spec.rb

require 'spec_helper'
require 'events/event.rb'

describe RoundTable::Events::Event do
  it "should have an immutable type" do
    expect { described_class.new }.to raise_error ArgumentError
    
    type = :text_event
    subject = described_class.new type
    subject.type.should eq(type)
    
    expect { subject.type = :test }.to raise_error
  end # it should have a type
  
  it "can save arbitrary data" do
    subject = described_class.new :data_event, :foo => "bar"
    subject[:foo].should eq("bar")
    
    subject[:baz] = "bizzle"
    subject[:baz].should eq("bizzle")
    
    subject.update({ :wibble => "wobble" })
    subject[:wibble].should eq("wobble")
  end # it can save arbitrary data
end # describe Event
