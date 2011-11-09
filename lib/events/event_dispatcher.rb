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
      
      bubble_event(event) if event[:bubbles]
    end # method dispatch_event
    
    #################
    # Event Listeners
    
    def add_listener(event_type, callback, params = {})
      raise ArgumentError.new("expected parameter to implement :call") unless callback.respond_to? :call
      params.update({ :event_type => event_type })
      
      # lazy initialize the listener registry and callbacks
      @listener_registry ||= Hash.new
      callbacks = @listener_registry[event_type] || Array.new
      
      callback_wrapper = EventCallback.new callback, params
      if callbacks.include? callback_wrapper
        return
      else      
        callbacks << callback_wrapper
        callbacks.sort! do |u, v|
          # reverse sort
          v <=> u
        end # sort!
        @listener_registry[event_type] = callbacks
        callback_wrapper
      end # if-else
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
    
    def remove_listeners(&block)
      return unless block_given? && @listener_registry.respond_to?(:[])
      
      @listener_registry.each do |event_type, callbacks|
        callbacks.each do |callback|
          callbacks.delete callback if block.call(callback)
        end # each
      end # each
    end # method remove_listeners
    
    def remove_generic_listener(callback)
      self.remove_listener :*, callback
    end # method remove_generic_listener
    
    ################
    # Event Bubbling
    
    def __bubble_attr__
      @__bubble_attr__ || :@parent
    end # method __bubble_attr__
    
    def __bubble_attr__=(attribute)
      @__bubble_attr__ = attribute if attribute.is_a?(String) || attribute.is_a?(Symbol)
    end # method __bubble_attr__
    private :__bubble_attr__, :__bubble_attr__=
    
    def bubble_parent
      if __bubble_attr__.to_s =~ /^\@\@/
        # class variable
        self.class.class_eval __bubble_attr__.to_s.split(/\s+/).first
        
        # The .split().first code is an attempt to protect against malicious
        # code, e.g. __bubble_attr__ = "@@foo; do_something_evil"
      elsif __bubble_attr__.to_s =~ /^\@/
        # instance variable
        self.instance_variable_get __bubble_attr__
      else
        # instance method
        self.send __bubble_attr__
      end # if-elsif-else
    end # method bubble_parent
    
    def bubble_event(event)
      return unless self.bubble_parent.is_a? EventDispatcher
      
      self.bubble_parent.dispatch_event(event)
    end # method bubble_event
  end # module EventDispatcher
end # module RoundTable::Events
