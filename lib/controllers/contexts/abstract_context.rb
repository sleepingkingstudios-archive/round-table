# lib/controllers/contexts/abstract_context.rb

require 'controllers/contexts/contexts'
require 'debug/logger_service'
require 'events/event_dispatcher'
require 'util/text_processor'
require 'util/tree_collection'

module RoundTable::Controllers::Contexts
  class AbstractContext
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
      dispatch_event Event.new :text_output, :text => string
    end # method puts
    
    #######################
    # Parsing Input Strings
    
    def parse(string)
      # logger.debug "#{self} parse(): string = \"#{string}\""
    end # method parse
  end # class AbstractContext
end # module RoundTable::Controllers::Contexts