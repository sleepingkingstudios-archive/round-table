# lib/controllers/base_context.rb

require 'controllers/controllers'
require 'controllers/abstract_controller'

module RoundTable::Controllers
  class BaseController < AbstractController
    action :help do |*args|
      case args.first
      when "help"
        self.puts "The \"help\" action prints some useful information about" +
          " the Round Table interactive adventure platform."
      when nil
        self.puts "To interact with the program, type commands into the" +
          " terminal, after the caret \">\". The program will consider your" +
          " input and print its response back into the terminal."
        self.puts ""
        self.puts "For a list of available actions, type \"what\". For more" +
          " information on an action, type the action followed by" +
          " \"help\"."
      else
        words = args
        tokens = Array.new

        until words.empty?
          action = words.join("_")

          if self.leaf.list_all_actions.include? action
            self.leaf.execute_action(action, "help")
            return
          end # if

          tokens.unshift words.pop
        end # while
        
        self.puts "I'm sorry, I don't recognize that action. For a list" +
          " of all available actions, type \"what\"."
      end # case args.first
    end # action help
    
    action :what do |*args|
      case args.first
      when "help"
        self.puts "The \"what\" action lists all of the actions that are" +
          " currently available. To use an action, type the action. For more" +
          " information on an action, type the action followed by" +
          " \"help\"."
      else
        self.puts "The following actions are available: " +
          self.list_all_actions.map{ |action| action.tr('_', ' ') }
          .join(", ") + "."
      end # case args.first
    end # action what
  end # class BaseController
end # module RoundTable::Controllers
