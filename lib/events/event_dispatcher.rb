# lib/events/event_dispatcher.rb

require 'events/events'
require 'events/event'
require 'events/event_callback'

module RoundTable::Events
  module EventDispatcher
    def dispatch_event(event, params = {})
      event[:original_dispatcher] ||= self
      event[:current_dispatcher] = self
      
      if @listener_registry.respond_to? :[]
        callbacks = @listener_registry[event.type] || Array.new
        
        # include generic listeners
        if event.type != :*
          callbacks += @listener_registry[:*] || Array.new
        end # if
        
        callbacks.each do |callback|
          callback.call event
        end # each
      end # if
    end # method dispatch_event
    
    #################
    # Event Listeners
    
    def add_listener(event_type, callback, params = {})
      raise ArgumentError.new("expected parameter to implement :call") unless callback.respond_to? :call
      
      # lazy initialize the listener registry and callbacks
      @listener_registry ||= Hash.new
      callbacks = @listener_registry[event_type] || Array.new
      
      callback_wrapper = EventCallback.new callback, params
      callbacks << callback_wrapper
      callbacks.sort! do |u, v|
        # reverse sort
        v <=> u
      end # sort!
      @listener_registry[event_type] = callbacks
    end # method add_listener
    
    def add_generic_listener(callback, params = {})
      self.add_listener :*, callback, params
    end # method add_generic_listener
    
    def remove_listener(event_type, callback)
      return unless @listener_registry.respond_to? :[]
      
      callbacks = @listener_registry[event_type]
      return unless callbacks.respond_to? :delete
      
      callbacks.each do |callback_wrapper|
        if callback_wrapper.callback == callback
          callbacks.delete callback_wrapper
        end # if
      end # each
    end # method remove_listener
    
    def remove_generic_listener(callback)
      self.remove_listener :*, callback
    end # method remove_generic_listener
  end # module EventDispatcher
end # module RoundTable::Events
