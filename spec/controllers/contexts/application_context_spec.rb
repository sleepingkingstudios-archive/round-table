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
end # describe ApplicationContext
