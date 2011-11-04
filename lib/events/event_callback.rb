# lib/events/event_callback.rb

require 'events/events'
require 'events/event'

module RoundTable::Events
  class EventCallback
    include Comparable
    
    def initialize(callback, params = {})
      raise ArgumentError.new("expected parameter to implement :call") unless callback.respond_to? :call
      
      @callback = callback
      self.priority = params[:priority]
    end # method initialize
    
    attr_reader :callback
    
    def ==(other)
      return self.callback == other.callback && self.priority == other.priority
    end # ==
    
    def <=>(other)
      return -1 if self.priority == :last  || other.priority == :first
      return  1 if self.priority == :first || other.priority == :last
      return self.priority <=> other.priority
    end # method <=>
    
    def call(event)
      raise ArgumentError.new("expected Event object") unless event.is_a? Event
      @callback.call(event)
    end # method call
    
    def priority
      @priority || 0
    end # method priority
    
    def priority=(value)
      @priority = value if value.is_a?(Integer) || [:first, :last].include?(value)
    end # method priority=
  end # class EventCallback
end # module RoundTable::Events
