# spec/controllers/application_controller_spec.rb

require 'spec_helper'
require 'controllers/abstract_controller'
require 'controllers/application_controller'

describe RoundTable::Controllers::ApplicationController do
  __vendor_path__ = VENDOR_PATH
  before :all do
    Object.send :remove_const, :VENDOR_PATH
    Object.send :const_set, :VENDOR_PATH, SPEC_PATH
  end # before :all
  
  after :all do
    Object.send :remove_const, :VENDOR_PATH
    Object.send :const_set, :VENDOR_PATH, __vendor_path__
  end # after :all
  
  it "is a kind of AbstractController" do
    subject.kind_of?(RoundTable::Controllers::AbstractController).should be true
  end # it is a kind of AbstractController
  
  it "has a quit action that dispatches a quit event" do
    subject.has_action?(:quit).should be true
    
    quit_handler = double('handler')
    quit_handler.should_receive(:quit)
    
    subject.add_listener :quit_application, Proc.new { |event|
      quit_handler.quit
    } # listener :quit_application
    
    subject.add_listener :text_input, Proc.new { |event|
      event[:text] = "yes\n"
    } # listener :text_input
    
    subject.execute_action :quit
  end # it has a quit action ...
  
  it "has a load action that loads a module" do
    output = double('mock_output')
    output.stub(:call)
    
    subject.add_listener :text_output, Proc.new { |event|
      output.call event[:text]
    } # listener :text_output
    
    output.should_receive(:call).with(/King of the Britons/)
    subject.execute_action :load, "Sir Not Appearing In This Film"
    
    output.should_receive(:call).with(/mightiest tree in the forest/)
    subject.parse "ni"
  end # it has a load action that loads a module
end # describe ApplicationController
