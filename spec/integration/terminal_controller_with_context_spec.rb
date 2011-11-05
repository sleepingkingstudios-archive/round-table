# spec/integration/terminal_controller_with_context_spec.rb

require 'spec_helper'
require 'controllers/terminal_controller'
require 'controllers/contexts/abstract_context'

describe "Integration" do
  describe "#TerminalController with AbstractContext" do
    include RoundTable::Controllers
    include RoundTable::Controllers::Contexts
    
    before :each do
      @input = double('input_stream')
      @input.stub(:gets) { "This is an input string.\n" }
      
      @output = double('output_stream')
      @output.stub(:puts)
      @output.stub(:print)
      
      @context = AbstractContext.new
      @controller = TerminalController.new @context, @input, @output
    end # before :each
  
    it "the context can request text from the controller" do
      @input.should_receive(:gets)
      
      @context.gets.should == "This is an input string.\n"
    end # it the context can retrieve text from the controller
    
    it "the context can send text to the controller to output" do
      @output.should_receive(:puts).with("This is an output string.\n")
      
      @context.puts "This is an output string.\n"
    end # it the context can send text to the controller to output
    
    it "the controller adds listeners to the new context" do
      context = AbstractContext.new
      @controller.root_context = context
      
      @input.should_receive(:gets)
      context.gets
    end # the controller adds listeners ...
    
    it "the controller removes listeners from the old context" do
      context = AbstractContext.new
      @controller.root_context = context
      
      @input.should_not_receive(:gets)
      @context.gets
    end # the controller removes listeners ...
  end # describe TerminalController with AbstractContext
end # describe Integration
