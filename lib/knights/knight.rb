# lib/knights/knight.rb

require 'controllers/contexts/abstract_context'
require 'knights/knights'
require 'util/text_processor'

module RoundTable::Knights
  class Knight
    include RoundTable::Util
    
    def build_context
      RoundTable::Controllers::Contexts::AbstractContext.new
    end # method build_context
    
    def message(*args)
      case args.map{|arg| arg.to_s }.join(" ").strip
      when "initialize"
        name = TextProcessor.to_snake_case(self.class.to_s.gsub(/\w+::/,'')).
          split("_").map{ |word| word.capitalize }.join(" ")
        "Initializing module #{name}."
      else
        "This is a default message."
      end # case
    end # method message
  end # class Knight
end # module RoundTable::Knights
