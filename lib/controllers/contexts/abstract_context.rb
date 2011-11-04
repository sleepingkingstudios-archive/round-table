# lib/controllers/contexts/abstract_context.rb

require 'controllers/contexts/contexts'
require 'debug/logger_service'
require 'util/text_processor'
require 'util/tree_collection'

module RoundTable::Controllers::Contexts
  class AbstractContext
    include RoundTable::Debug::LoggerService
    include RoundTable::Util::TextProcessor
    include RoundTable::Util::TreeCollection
    
    def initialize
      @parent = nil
      @children = Array.new
    end # method initialize
    
    #######################
    # Parsing Input Strings
    
    def parse(string)
      
    end # method parse
  end # class AbstractContext
end # module RoundTable::Controllers::Contexts