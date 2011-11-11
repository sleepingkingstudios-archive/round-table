# lib/controllers/contexts/abstract_context.rb

require 'controllers/contexts/contexts'
require 'controllers/contexts/action_performer'
require 'debug/logger_service'
require 'events/event_dispatcher'
require 'util/text_processor'
require 'util/tree_collection'

module RoundTable::Controllers::Contexts
  class AbstractContext < ActionPerformer
    include RoundTable::Debug::LoggerService
    include RoundTable::Events
    include RoundTable::Events::EventDispatcher
    include RoundTable::Util::TextProcessor
    include RoundTable::Util::TreeCollection
    
    def initialize
      @parent = nil
      @children = Array.new
    end # method initialize
    
    def to_s
      self.class.to_s.gsub(/\w+::/, "")
    end # method to_s
    
    #######################
    # Text Input and Output
    
    def gets
      event = Event.new :text_input
      dispatch_event event
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
    
    def list_all_actions
      actions = self.list_own_actions
      actions += @parent.list_all_actions unless self.root?
      actions.compact.uniq.sort
    end # method list_all_actions
    
    def missing_action(action, *tokens)
      if self.root?
        self.puts "I'm sorry, I don't recognize that action.\n\nFor a list" +
          " of all available actions, type \"what\". For information on an" +
          " action, type the action followed by \"help\". For general" +
          " information, type \"help\"."
      else
        self.parent.execute_action action, *tokens
      end # if-else
    end # method missing_action
    
    #######################
    # Parsing Input Strings
    
    def parse(string)
      tokens = tokenize string
      action = tokens.shift
      
      self.leaf.execute_action action, *tokens
    end # method parse
  end # class AbstractContext
end # module RoundTable::Controllers::Contexts