# lib/errors/data_error.rb

=begin
  A DataError is dispatched when there is an error in data loaded from an
  external source, such as a required field that is left empty.
=end

require 'errors/errors'

module RoundTable::Errors
  class DataError < StandardError
    def initialize(message = nil, source = nil)
      super(message)
      @source = source
    end # method initialize
    
    attr_accessor :source
  end # class DataError
end # module RoundTable::Errors
