# spec/integration/terminal_controller_with_context_spec.rb

require 'spec_helper'
require 'controllers/terminal_controller'
require 'controllers/contexts/application_context'

describe "Integration" do
  describe "#TerminalController with ApplicationContext" do
    include RoundTable::Controllers
    include RoundTable::Controllers::Contexts
    
    before :each do
      @input = double('input_stream')
      @input.stub(:gets)
      
      @output = double('output_stream')
      @output.stub(:puts)
      @output.stub(:print)
      
      @context = ApplicationContext.new
      @controller = TerminalController.new @context, @input, @output
    end # before :each
    
    #######################
    # Text Input and Output
    
    it "the context can request text from the controller" do
      @input.stub(:gets) { "This is an input string.\n" }
      @input.should_receive(:gets)
      
      @context.gets.should == "This is an input string.\n"
    end # it the context can retrieve text from the controller
    
    it "the context can send text to the controller to output" do
      @output.should_receive(:puts).with("This is an output string.\n")
      
      @context.puts "This is an output string.\n"
    end # it the context can send text to the controller to output
    
    it "the controller adds listeners to the new context" do
      context = ApplicationContext.new
      @controller.root_context = context
      
      @input.should_receive(:gets)
      context.gets
    end # the controller adds listeners ...
    
    it "the controller removes listeners from the old context" do
      context = ApplicationContext.new
      @controller.root_context = context
      
      @input.should_not_receive(:gets)
      @context.gets
    end # the controller removes listeners ...
    
    #####################
    # Running the IO Loop
    
    it "exits the IO loop upon receiving a kill signal" do
      @input.stub(:gets) { "verb object" }
      @output.should_receive(:puts)
      
      def kill_loop
        @controller.kill!
      end # function kill_loop
      
      thread = Thread.new do
        sleep 0.001
        kill_loop
      end # Thread.new
      
      logger.debug "Halting :debug logging due to loop..."
      log_level = logger.log_level
      logger.log_level = 1
      @controller.io_loop
      logger.log_level = log_level
      logger.debug "Resuming :debug logging"
      
      thread.join
    end # it exits the IO loop upon receiving a kill signal
    
    it "exits the IO loop upon confirmation of the quit action" do
      @input.stub(:gets).and_return("quit\n", "yes\n")
      @input.should_receive(:gets).twice
      @output.should_receive(:puts).with(/\(yes\/no\)/)
      
      def kill_loop
        @controller.kill!
      end # function kill_loop
      
      thread = Thread.new do
        sleep 0.001
        kill_loop
      end # Thread.new
      
      logger.debug "Halting :debug logging due to loop..."
      log_level = logger.log_level
      logger.log_level = 1
      @controller.io_loop
      logger.log_level = log_level
      logger.debug "Resuming :debug logging"
      
      thread.join
    end # it exits the IO loop upon receiving a quit event
  end # describe TerminalController with ApplicationContext
end # describe Integration
