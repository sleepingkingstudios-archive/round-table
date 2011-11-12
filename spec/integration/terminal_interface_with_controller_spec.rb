# spec/integration/terminal_interface_with_controller_spec.rb

require 'spec_helper'
require 'controllers/application_controller'
require 'interfaces/terminal_interface'

describe "Integration" do
  describe "#TerminalInterface with ApplicationController" do
    include RoundTable::Controllers
    include RoundTable::Interfaces
    
    before :each do
      @input = double('input_stream')
      @input.stub(:gets)
      
      @output = double('output_stream')
      @output.stub(:puts)
      @output.stub(:print)
      
      @controller = ApplicationController.new
      @interface = TerminalInterface.new @controller, @input, @output
    end # before :each
    
    #######################
    # Text Input and Output
    
    it "the controller can request text from the interface" do
      @input.stub(:gets) { "This is an input string.\n" }
      @input.should_receive(:gets)
      
      @controller.gets.should == "This is an input string.\n"
    end # the controller can request text from the interface
    
    it "the controller can send text to the interface to output" do
      @output.should_receive(:puts).with("This is an output string.\n")
      
      @controller.puts "This is an output string.\n"
    end # the controller can send text to the interface to output
    
    it "the interface adds listeners to the new controller" do
      controller = ApplicationController.new
      @interface.root_controller = controller
      
      @input.should_receive(:gets)
      controller.gets
    end # the interface adds listeners to the new controller
    
    it "the listener removes listeners from the old controller" do
      controller = ApplicationController.new
      @interface.root_controller = controller
      
      @input.should_not_receive(:gets)
      @controller.gets
    end # the listener removes listeners from the old controller
    
    #####################
    # Running the IO Loop
    
    it "exits the IO loop upon receiving a kill signal" do
      @input.stub(:gets) { "verb object" }
      @output.should_receive(:puts)
      
      def kill_loop
        @interface.kill!
      end # function kill_loop
      
      thread = Thread.new do
        sleep 0.001
        kill_loop
      end # Thread.new
      
      logger.debug "Halting :debug logging due to loop..."
      log_level = logger.log_level
      logger.log_level = 1
      @interface.io_loop
      logger.log_level = log_level
      logger.debug "Resuming :debug logging"
      
      thread.join
    end # it exits the IO loop upon receiving a kill signal
    
    it "exits the IO loop upon confirmation of the quit action" do
      @input.stub(:gets).and_return("quit\n", "yes\n")
      @input.should_receive(:gets).twice
      @output.should_receive(:puts).with(/\(yes\/no\)/)
      
      def kill_loop
        @interface.kill!
      end # function kill_loop
      
      thread = Thread.new do
        sleep 0.001
        kill_loop
      end # Thread.new
      
      logger.debug "Halting :debug logging due to loop..."
      log_level = logger.log_level
      logger.log_level = 1
      @interface.io_loop
      logger.log_level = log_level
      logger.debug "Resuming :debug logging"
      
      thread.join
    end # it exits the IO loop upon receiving a quit event
  end # describe TerminalController with ApplicationController
end # describe Integration
