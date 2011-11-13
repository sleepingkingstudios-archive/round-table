# spec/controllers/action_delegate_helper.rb

require 'spec_helper'
require 'controllers/action_performer_helper'
require 'events/event'
require 'events/event_dispatcher'
require 'controllers/action_delegate'

shared_examples "an ActionDelegate" do
  it_behaves_like "an ActionPerformer"
  
  it "should be an ActionDelegate" do
    described_class.should <= RoundTable::Controllers::ActionDelegate
  end # it should be an ActionPerformer
  
  it "can be instantiated without errors" do
    described_class.new
  end # it can be instantiated ...
  
  it "has a to_key method that returns a string" do
    subject.to_key.should be_a String
  end # it has a to_key method that returns a string
  
  it "can send text output events" do
    output = "This is an output string."
    
    mock = double('callable')
    mock.stub(:call)
    mock.should_receive(:call).with(/#{output}/)
    
    subject.add_listener :text_output, Proc.new { |event|
      mock.call event[:text]
    } # end listener :text_output
    
    subject.puts output
  end # it can send text output events
  
  it "can send text input events" do
    input = "This is an input string."
    
    subject.add_listener :text_input, Proc.new { |event|
      event[:text] = input
    } # end listener :text_input
    
    subject.gets.should =~ /#{input}/
  end # it can send text input events
end # an ActionDelegate
