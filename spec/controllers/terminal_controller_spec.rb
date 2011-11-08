# spec/controllers/terminal_controller_spec.rb

require 'spec_helper'
require 'controllers/terminal_controller'
require 'controllers/contexts/abstract_context'

describe RoundTable::Controllers::TerminalController do
  include RoundTable::Controllers
  
  before :each do
    @context = Contexts::AbstractContext.new
  end # before :each
  
  it "runs an IO loop" do
    input = double('input_stream')
    input.stub(:gets)
    output = double('output_stream')
    output.stub(:print)
    output.stub(:puts)
    
    @controller = TerminalController.new @context, input, output
    
    def kill_loop
      @controller.kill!
    end # function kill_loop
    
    thread = Thread.new do
      sleep 0.05
      kill_loop
    end # Thread.new
    
    logger.debug "Halting :debug logging due to loop..."
    log_level = logger.log_level
    logger.log_level = 1
    @controller.io_loop
    logger.log_level = log_level
    logger.debug "Resuming :debug logging"
    
    thread.join
  end # it runs an IO loop
end # describe RoundTable::Controllers::TerminalController
