# spec/controllers/terminal_controller_spec.rb

require 'spec_helper'
require 'controllers/terminal_controller'

describe RoundTable::Controllers::TerminalController do
  include RoundTable::Controllers
  
  it "runs an IO loop" do
    input = double('input_stream')
    input.stub(:gets) { "quit\n" }
    output = double('output_stream')
    output.stub(:print)
    output.stub(:puts)
    
    subject = TerminalController.new input, output
    subject.io_loop
  end # it runs an IO loop
end # describe RoundTable::Controllers::TerminalController
