# lib/knights/knight.rb

require 'controllers/contexts/abstract_context'
require 'knights/knights'

module RoundTable::Knights
  class Knight
    def build_context
      RoundTable::Controllers::Contexts::AbstractContext.new
    end # method build_context
  end # class Knight
end # module RoundTable::Knights
