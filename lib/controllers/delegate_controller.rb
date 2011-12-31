# lib/controllers/delegate_controller.rb

require 'controllers/controllers'
require 'controllers/action_delegate'
require 'controllers/base_controller'
require 'util/argument_validator'

module RoundTable::Controllers
  class DelegateController < BaseController
    include RoundTable::Util::ArgumentValidator
    
    def initialize
      super
      
      @delegates = Hash.new
    end # method initialize
    
    ####################
    # Managing Delegates
    
    def add_delegate(key, delegate)
      validate_argument key, :allow_nil? => true
      validate_argument delegate, :as => "delegate", :type => ActionDelegate
      
      delegate.add_listener :*, Proc.new { |event|
        self.dispatch_event(event)
      }, :references => self
      
      @delegates[key] = delegate
    end # method add_delegate
    
    def has_delegate?(delegate)
      @delegates.has_value? delegate
    end # has_delegate?
    
    def has_key?(key)
      @delegates.has_key? key
    end # has_key?
    
    def remove_delegate(delegate)
      validate_argument delegate, :as => "delegate", :type => ActionDelegate
      return unless self.has_delegate? delegate
      
      delegate.remove_listeners { |callback|
        callback.data[:references] == self
      } # remove_listeners
      
      @delegates.delete_if { |key, value| value === delegate }
    end # method remove_delegate
    
    def remove_delegate_by_key(key)
      raise ArgumentError.new "no delegate with key #{key.inspect}" unless self.has_key? key
      self.remove_delegate @delegates[key]
    end # method remove_delegate_by_key
    
    ###################
    # Executing Actions
    
    def execute_action(action, *tokens)
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
      @delegates.values.select { |delegate| delegate.has_action? action }
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