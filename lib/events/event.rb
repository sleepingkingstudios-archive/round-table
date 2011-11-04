# lib/events/event.rb

require 'events/events'

module RoundTable::Events
  class Event
    def initialize(type, params = {})
      @type = type
      @data = {}
      @data.update(params) if params.is_a? Hash
    end # method initialize
    
    attr_reader :type
    
    def [](key)
      @data[key]
    end # method []
    
    def []=(key, value)
      @data[key] = value
    end # method []=
  end # class Event
end # module RoundTable::Events
