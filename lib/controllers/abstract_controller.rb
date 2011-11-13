# lib/controllers/abstract_controller.rb

require 'controllers/controllers'
require 'controllers/action_delegate'
require 'debug/logger_service'
require 'util/tree_collection'

module RoundTable::Controllers
  class AbstractController < ActionDelegate
    include RoundTable::Debug::LoggerService
    include RoundTable::Util::TreeCollection
    
    def initialize
      @parent = nil
      @children = Array.new
    end # method initialize
    
    ###################
    # Executing Actions
    
    def missing_action(action, *tokens)
      if self.root?
        self.puts "I'm sorry, I don't know how to \"#{action}\".\n\nFor a" +
          " list of all available actions, type \"what\". For information on" +
          " an action, type the action followed by \"help\". For general" +
          " information, type \"help\"."
      else
        self.parent.execute_action action, *tokens
      end # if-else
    end # method missing_action
    
    def list_all_actions
      actions = self.list_own_actions
      actions += @parent.list_all_actions unless self.root?
      actions.compact.uniq.sort
    end # method list_all_actions
    
    #######################
    # Parsing Input Strings
    
    def parse(string)
      words = self.tokenize string
      tokens = Array.new
      
      until words.empty?
        action = words.join("_")
        
        if self.leaf.list_all_actions.include? action
          self.leaf.execute_action(action, *tokens)
          return
        end # if
        
        tokens.unshift words.pop
      end # while
      
      self.missing_action(string, [])
    end # method parse
  end # class AbstractController
end # module RoundTable::Controllers::Contexts