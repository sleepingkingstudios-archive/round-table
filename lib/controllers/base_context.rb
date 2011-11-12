# lib/controllers/contexts/base_context.rb

require 'controllers/contexts/contexts'
require 'controllers/contexts/abstract_context'

module RoundTable::Controllers::Contexts
  class BaseContext < AbstractContext
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
        if self.has_action? args.first.to_s
          self.execute_action args.first, "help"
        else
          self.puts "I'm sorry, I don't recognize that action. For a list" +
            " of all available actions, type \"what\"."
        end # if-else
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
          self.list_all_actions.join(", ") + "."
      end # case args.first
    end # action what
  end # class BaseContext
end # module RoundTable::Controllers::Contexts
