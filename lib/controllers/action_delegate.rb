# lib/controllers/action_delegate.rb

require 'controllers/controllers'
require 'controllers/action_performer'
require 'events/event'
require 'events/event_dispatcher'
require 'util/text_processor'

module RoundTable::Controllers
  class ActionDelegate < ActionPerformer
    include RoundTable::Events
    include RoundTable::Events::EventDispatcher
    include RoundTable::Util::TextProcessor
    
    def to_key
      self.to_s
    end # method to_key
    
    def to_s
      self.class.to_s.gsub(/\w+::/, "")
    end # method to_s
    
    #######################
    # Text Input and Output
    
    def gets
      event = Event.new :text_input
      dispatch_event event, :bubbles => :true
      event[:text]
    end # method gets
    
    def puts(string)
      dispatch_event Event.new :text_output, :text => self.break_text(string, 80), :bubbles => :true
    end # method puts
    
    def print(string)
      dispatch_event Event.new :text_output, :text => self.break_text(string, 80), :bubbles => :true, :strip_whitespace => :true
    end # method print
    
    ###################
    # Executing Actions
    
  end # class ActionDelegate
end # module RoundTable::Controllers
