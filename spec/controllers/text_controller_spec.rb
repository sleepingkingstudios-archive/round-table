# spec/controllers/text_controller_spec.rb

require 'spec_helper'
require 'controllers/text_controller'

describe RoundTable::Controllers::TextController do
  include RoundTable::Controllers
  
  it "requires an input stream that supports :gets" do
    expect { TextController.new nil, $stdout }.to raise_error(ArgumentError)
  end # it requires an input stream that supports :gets
  
  it "requires an input stream that supports :puts and :print" do
    expect { TextController.new $stdin, nil }.to raise_error(ArgumentError)
  end # it requires an input stream that supports :puts and :print
  
  it "can print text to an IO stream" do
    message = "This is a sample message."
    
    input = double('input_stream')
    input.stub(:gets)
    output = double('output_stream')
    output.stub(:print).stub(:puts)
    output.should_receive(:print).with("> ")
    output.should_receive(:puts).with(message)
    
    subject = TextController.new input, output
    subject.puts message
    subject.print "> "
  end # it can print text to an IO interface
end # describe RoundTable::Controllers::TextController
