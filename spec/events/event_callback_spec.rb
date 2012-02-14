# spec/events/event_callback_spec.rb

require 'spec_helper'
require 'events/event'
require 'events/event_callback'

describe RoundTable::Events::EventCallback do
  before :each do
    @callback = double('mock_callable')
    @callback.stub(:call)
    
    @event = RoundTable::Events::Event.new :test_event
  end # before :each
  
  describe "initialization" do
    it { expect { described_class.new }.to raise_error ArgumentError }
    it { expect { described_class.new nil }.to raise_error ArgumentError }
    it { expect { described_class.new :symbol }.to raise_error ArgumentError }
    it { expect { described_class.new "string" }.to raise_error ArgumentError }
    it { expect { described_class.new @callback }.not_to raise_error }
  end # describe initialization
  
  context "(initialized)" do
    subject { described_class.new @callback }
    
    it "should only be equal if it has the same callback and priority" do
      subject.should == described_class.new(@callback)
    
      other_callback = double('mock_callable')
      other_callback.stub(:call)
    
      subject.should_not eq(described_class.new other_callback)
      subject.should_not eq(described_class.new @callback, :priority => :first)
    end # it should only be equal if it is the same object
  
    it "can be called taking an event object" do
      @callback.should_receive(:call)
    
      subject = described_class.new @callback
      expect { subject.call }.to raise_error ArgumentError
      expect { subject.call nil }.to raise_error ArgumentError
      expect { subject.call :symbol }.to raise_error ArgumentError
      expect { subject.call "string" }.to raise_error ArgumentError
    
      subject.call @event
    end # it can be called
  
    it "has a callback" do
      subject = described_class.new @callback
      subject.callback.should eq(@callback)
    end # it has a callback
  
    it "has a priority" do
      subject = described_class.new @callback
      subject.priority.should be 0
    
      subject = described_class.new @callback, :priority => 5
      subject.priority.should be 5
    
      subject = described_class.new @callback, :priority => :first
      subject.priority.should be :first
    
      subject = described_class.new @callback, :priority => :last
      subject.priority.should be :last
    
      subject = described_class.new @callback, :priority => nil
      subject.priority.should be 0
    
      subject = described_class.new @callback, :priority => :foo
      subject.priority.should be 0
    end # it has a priority
  
    it "can be sorted by priority" do
      first = described_class.new @callback, :priority => :first
      zero  = described_class.new @callback, :priority => 0
      one   = described_class.new @callback, :priority => 1
      two   = described_class.new @callback, :priority => 2
      last  = described_class.new @callback, :priority => :last
    
      callbacks = [one, two, zero, last, first]
      callbacks.sort# .should eq([first, zero, one, two, last])
    end # it can be sorted by priority
  
    it "has custom data" do
      subject = described_class.new @callback, :priority => 7, :foo => "bar"
      subject.data[:priority].should be nil
      subject.data[:foo].should == "bar"
    
      subject.data[:baz] = "bizzle"
      subject.data[:baz].should == "bizzle"
    end # it has custom data
  end # context (initialized)
end # describe EventCallback
