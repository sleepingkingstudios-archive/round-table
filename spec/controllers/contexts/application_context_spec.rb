# spec/controllers/contexts/application_context_spec.rb

require 'spec_helper'
require 'controllers/contexts/abstract_context'
require 'controllers/contexts/application_context'

describe RoundTable::Controllers::Contexts::ApplicationContext do
  include RoundTable::Controllers::Contexts
  
  it "is a kind of AbstractContext" do
    subject.kind_of?(AbstractContext).should be true
  end # it is a kind of AbstractContext
  
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
    pending
    output = double('mock_output')
    output.stub(:call)
    
    subject.add_listener :text_output, Proc.new { |event|
      output.call event[:text]
    } # listener :text_output
    
    output.should_receive(:call).with(/mightiest tree in the forest/)
    
    subject.execute_action :load, "Sir Not Appearing In This Film"
  end # it has a load action that loads a module
end # describe ApplicationContext
