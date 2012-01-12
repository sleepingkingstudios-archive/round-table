# lib/interfaces/text_interface.rb

require 'interfaces/interfaces'
require 'controllers/abstract_controller'
require 'debug/logger_service'
require 'util/argument_validator'
require 'util/text_processor'

module RoundTable::Interfaces
  class TextInterface
    include RoundTable::Debug::LoggerService
    include RoundTable::Util::ArgumentValidator
    include RoundTable::Util::TextProcessor
    
    def initialize(controller, input, output)
      self.root_controller = controller
      
      validate_argument input, :as => "input", :respond_to? => :gets
      @input = input
      
      validate_argument output, :as => "output", :respond_to? => [:puts, :print]
      @output = output
    end # method initialize
    
    attr_reader :root_controller
    def root_controller=(controller)
      validate_argument controller, :as => "controller", :type => RoundTable::Controllers::AbstractController
      @root_controller = controller
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
    
    def put_ary(ary, params = {})
      ary = [ary].flatten
      config = {
        :allow_skip => true,
        :as => "text"
      } # end config
      config.update(params) if params.is_a? Hash
      
      ary.each_with_index do |value, index|
        self.puts value.to_s
        
        if index == 0
          if config[:allow_skip]
            self.puts "(press Enter to continue, or type \"skip\" to skip" +
              " this #{config[:as]})"
          else
            self.puts "(press Enter to continue)"
          end # if-else
        end # if
        
        if config[:allow_skip] and (index + 1) < ary.length
          return if self.gets =~ /^skip/i
        end # if
      end # each with index
    end # method put_ary
  end # class TextInterface
end # module RoundTable::Interfaces
