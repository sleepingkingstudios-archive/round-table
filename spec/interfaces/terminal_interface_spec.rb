# spec/interfaces/terminal_interface_spec.rb

require 'spec_helper'
require 'controllers/abstract_controller'
require 'interfaces/terminal_interface'

describe RoundTable::Interfaces::TerminalInterface do
  include RoundTable::Controllers
  include RoundTable::Interfaces
  
  let(:input) {
    input = mock('input')
    input.tap { |obj| obj.stub :respond_to? do true end }
    input.tap { |obj| obj.stub :gets }
  } # end let :input
  
  before :each do
    @controller = AbstractController.new
  end # before :each
  
  it "runs an IO loop" do
    output = double('output_stream')
    output.stub(:print)
    output.stub(:puts)
    
    @interface = TerminalInterface.new @controller, input, output
    
    def kill_loop
      @interface.kill!
    end # function kill_loop
    
    thread = Thread.new do
      sleep 0.05
      kill_loop
    end # Thread.new
    
    logger.debug "Halting :debug logging due to loop..."
    log_level = logger.log_level
    logger.log_level = 1
    @interface.io_loop
    logger.log_level = log_level
    logger.debug "Resuming :debug logging"
    
    thread.join
  end # it runs an IO loop
end # describe RoundTable::Controllers::TerminalController
