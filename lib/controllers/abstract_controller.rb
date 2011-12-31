# lib/controllers/abstract_controller.rb

require 'controllers/controllers'
require 'controllers/action_delegate'
require 'debug/logger_service'
require 'util/text_processor'
require 'util/tree_collection'

module RoundTable::Controllers
  class AbstractController < ActionDelegate
    include RoundTable::Debug::LoggerService
    include RoundTable::Util::TextProcessor
    include RoundTable::Util::TreeCollection
    
    def initialize
      @parent = nil
      @children = Array.new
    end # method initialize
    attr_reader :input_string, :input_action, :input_args
    
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
    
    def list_all_aliases
      aliases = self.list_own_aliases
      aliases += @parent.list_all_aliases unless self.root?
      aliases.compact.uniq.sort
    end # method list_all_aliases
    
    def list_all_actions
      actions = self.list_own_actions
      actions += @parent.list_all_actions unless self.root?
      actions.compact.uniq.sort
    end # method list_all_actions
    
    #######################
    # Parsing Input Strings
    
    def parse(string)
      @input_string = string
      if string.empty?
        self.puts "Please enter an action."
        return
      end # if
      
      words = self.tokenize string
      tokens = Array.new
      
      until words.empty?
        action = words.join("_")
        logger.debug "#{self.class}: action = #{action}, rest = #{words.inspect}"
        
        actions = self.leaf.list_all_actions + self.leaf.list_all_aliases
        
        if actions.include? action
          @input_action = @input_string.match(/^#{words.join(" ")}/i).to_a.first
          @input_args   = @input_string.gsub(/^#{@input_action} /i, "")
          
          self.leaf.execute_action(action, *tokens)
          return
        end # if
        
        tokens.unshift words.pop
      end # while
      
      self.missing_action(string, [])
    end # method parse
  end # class AbstractController
end # module RoundTable::Controllers::Contexts