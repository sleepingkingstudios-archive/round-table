# lib/knights/knight.rb

require 'controllers/abstract_controller'
require 'knights/knights'
require 'util/text_processor'

module RoundTable::Knights
  class Knight
    include RoundTable::Util
    
    def controller
      RoundTable::Controllers::AbstractController.new
    end # method controller
    
    def message(*args)
      case args.map{|arg| arg.to_s }.join(" ").strip
      when "load"
        name = TextProcessor.to_snake_case(self.class.to_s.gsub(/\w+::/,'')).
          split("_").map{ |word| word.capitalize }.join(" ")
        "Initializing module #{name}."
      when "quit"
        "Thank you for playing!"
      else
        "This is a default message."
      end # case
    end # method message
  end # class Knight
end # module RoundTable::Knights
