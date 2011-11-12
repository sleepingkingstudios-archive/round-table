# spec/interfaces/text_interface_spec.rb

require 'spec_helper'
require 'controllers/abstract_controller'
require 'interfaces/text_interface'

describe RoundTable::Interfaces::TextInterface do
  include RoundTable::Controllers
  include RoundTable::Interfaces
  
  before :each do
    @controller = AbstractController.new
  end # before :each
  
  it "requires an input stream that supports :gets" do
    expect { TextInterface.new @controller, nil, $stdout }.to raise_error(ArgumentError)
  end # it requires an input stream that supports :gets
  
  it "requires an input stream that supports :puts and :print" do
    expect { TextInterface.new @controller, $stdin, nil }.to raise_error(ArgumentError)
  end # it requires an input stream that supports :puts and :print
  
  it "requires a controller" do
    expect { TextInterface.new nil, $stdin, $stdout }.to raise_error(ArgumentError)
    
    subject = TextInterface.new @controller, $stdin, $stdout
    subject.root_controller.should be @controller
    
    other_controller = AbstractController.new
    subject.root_controller = other_controller
    subject.root_controller.should be other_controller
  end # it requires a controller
  
  it "can print text to an IO stream" do
    message = "This is a sample message."
    
    input = double('input_stream')
    input.stub(:gets)
    output = double('output_stream')
    output.stub(:print)
    output.stub(:puts)
    output.should_receive(:print).with("> ")
    output.should_receive(:puts).with(message)
    
    subject = TextInterface.new @controller, input, output
    subject.puts message
    subject.print "> "
  end # it can print text to an IO interface
end # describe RoundTable::Interfaces::TextInterface
