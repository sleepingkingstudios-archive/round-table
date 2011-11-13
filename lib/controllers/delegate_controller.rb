# lib/controllers/delegate_controller.rb

require 'controllers/controllers'
require 'controllers/action_delegate'
require 'controllers/base_controller'

module RoundTable::Controllers
  class DelegateController < BaseController
    def initialize
      super
      
      @delegates = Hash.new
    end # method initialize
    
    ####################
    # Managing Delegates
    
    def add_delegate(delegate)
      raise ArgumentError.new("delegate must be an ActionDelegate") unless delegate.is_a? ActionDelegate
      
      delegate.add_listener :*, Proc.new { |event|
        self.dispatch_event(event)
      }, :references => self
      
      @delegates[delegate.to_key] = delegate
    end # method add_delegate
    
    def remove_delegate(delegate)
      return unless @delegates.include? delegate.to_key
      
      delegate.remove_listeners { |callback|
        callback.data[:references] == self
      } # remove_listeners
      
      @delegates.delete(delegate.to_key)
    end # method remove_delegate
    
    ###################
    # Executing Actions
    
    def execute_action(action, *tokens)
      if self.has_action? action
        super and return
      end # if
      
      @delegates.each do |key, delegate|
        if delegate.has_action?(action) && tokens.join(" ") =~ /^#{key}/
          delegate.execute_action action, *tokens
          return
        end # if
      end # each
      
      super
    end # method execute_action
    
    #######################
    # Introspecting Actions
    
    def delegates_for(action)
      delegates = Array.new
      
      delegates << self if self.has_action? action
      @delegates.each do |key, delegate|
        delegates << delegate if delegate.has_action? action
      end # each
      
      delegates
    end # method delegates_for
    
    def list_all_actions
      actions = super
      
      @delegates.each do |key, delegate|
        if delegate.respond_to? :list_all_actions
          actions += delegate.list_all_actions
        else
          actions += delegate.list_own_actions
        end # if-else
      end # each
      
      actions.uniq.sort
    end # method list_all_actions
  end # class DelegateController
end # module RoundTable::Controllers