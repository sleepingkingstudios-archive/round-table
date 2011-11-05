# spec/controllers/text_controller_spec.rb

require 'spec_helper'
require 'controllers/text_controller'

describe RoundTable::Controllers::TextController do
  include RoundTable::Controllers
  
  before :each do
    @context = Contexts::AbstractContext.new
  end # before :each
  
  it "requires an input stream that supports :gets" do
    expect { TextController.new @context, nil, $stdout }.to raise_error(ArgumentError)
  end # it requires an input stream that supports :gets
  
  it "requires an input stream that supports :puts and :print" do
    expect { TextController.new @context, $stdin, nil }.to raise_error(ArgumentError)
  end # it requires an input stream that supports :puts and :print
  
  it "requires a text context" do
    expect { TextController.new nil, $stdin, $stdout }.to raise_error(ArgumentError)
    
    subject = TextController.new @context, $stdin, $stdout
    subject.root_context.should be @context
    
    other_context = Contexts::AbstractContext.new
    subject.root_context = other_context
    subject.root_context.should be other_context
  end # it requires a text context
  
  it "can print text to an IO stream" do
    message = "This is a sample message."
    
    input = double('input_stream')
    input.stub(:gets)
    output = double('output_stream')
    output.stub(:print)
    output.stub(:puts)
    output.should_receive(:print).with("> ")
    output.should_receive(:puts).with(message)
    
    subject = TextController.new @context, input, output
    subject.puts message
    subject.print "> "
  end # it can print text to an IO interface
end # describe RoundTable::Controllers::TextController
