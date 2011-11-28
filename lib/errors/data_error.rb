# lib/errors/data_error.rb

require 'errors/errors'

module RoundTable::Errors
  class DataError < StandardError
    attr_accessor :source
  end # class DataError
end # module RoundTable::Errors
