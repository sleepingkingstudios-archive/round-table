# lib/controllers/text_controller.rb

require 'controllers/controllers'
require 'controllers/contexts/abstract_context'
require 'debug/logger_service'

module RoundTable::Controllers
  class TextController
    include RoundTable::Debug::LoggerService
    
    def initialize(root_context, input, output)
      raise ArgumentError.new("context must be an AbstractContext") unless root_context.is_a? RoundTable::Controllers::Contexts::AbstractContext
      self.root_context = root_context
      
      raise ArgumentError.new("input stream must support :gets method.") unless input.respond_to?(:gets)
      @input = input
      
      raise ArgumentError.new("output stream must support :puts method.") unless output.respond_to?(:puts)
      raise ArgumentError.new("output stream must support :print method.") unless output.respond_to?(:print)
      @output = output
    end # method initialize
    
    attr_reader :root_context
    def root_context=(context)
      @root_context = context if context.is_a? RoundTable::Controllers::Contexts::AbstractContext
    end # mutator context=
    
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
