# lib/interfaces/text_interface.rb

require 'interfaces/interfaces'
require 'controllers/abstract_controller'
require 'debug/logger_service'

module RoundTable::Interfaces
  class TextInterface
    include RoundTable::Debug::LoggerService
    
    def initialize(root_controller, input, output)
      unless root_controller.is_a? RoundTable::Controllers::AbstractController
        raise ArgumentError.new("controller must be an AbstractController, received #{root_controller.class}")
      end # unless
      self.root_controller = root_controller
      
      raise ArgumentError.new("input stream must support :gets method.") unless input.respond_to?(:gets)
      @input = input
      
      raise ArgumentError.new("output stream must support :puts method.") unless output.respond_to?(:puts)
      raise ArgumentError.new("output stream must support :print method.") unless output.respond_to?(:print)
      @output = output
    end # method initialize
    
    attr_reader :root_controller
    def root_controller=(context)
      @root_controller = context if context.is_a? RoundTable::Controllers::AbstractController
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
  end # class TextInterface
end # module RoundTable::Interfaces
