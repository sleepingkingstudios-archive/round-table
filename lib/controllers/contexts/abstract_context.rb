# lib/controllers/contexts/abstract_context.rb

require 'controllers/contexts/contexts'
require 'debug/logger_service'
require 'util/tree_collection'

module RoundTable::Controllers::Contexts
  class AbstractContext
    include RoundTable::Debug::LoggerService
    include RoundTable::Util::TreeCollection
    
    def initialize
      @parent = nil
      @children = Array.new
    end # method initialize
  end # class AbstractContext
end # module RoundTable::Controllers::Contexts