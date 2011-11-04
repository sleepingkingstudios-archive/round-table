# lib/controllers/text_controller.rb

require 'controllers/controllers'
require 'debug/logger_service'

module RoundTable::Controllers
  class TextController
    include RoundTable::Debug::LoggerService
    
    def initialize(input, output)
      raise ArgumentError.new("Input stream must support :gets method.") unless input.respond_to?(:gets)
      @input = input
      
      raise ArgumentError.new("Output stream must support :puts method.") unless output.respond_to?(:puts)
      raise ArgumentError.new("Output stream must support :print method.") unless output.respond_to?(:print)
      @output = output
    end # method initialize
    
    #######################
    # Text Input and Output
    
    def gets
      @input.gets
    end # method gets
    
    def print(string)
      @output.print string
    end # method print
    
    def puts(string)
      @output.puts string
    end # method puts
  end # class TextController
end # module RoundTable::Controllers
