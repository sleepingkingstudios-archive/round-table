# lib/controllers/contexts/application_context.rb

require 'controllers/contexts/contexts'
require 'controllers/contexts/base_context'

module RoundTable::Controllers::Contexts
  class ApplicationContext < BaseContext
    action :quit do |*args|
      case args.first
      when "help"
        self.puts "The \"quit\" action exits the application. The user is" +
          " prompted for a confirmation. To skip the confirmation, type" +
          " \"quit force\", however, this may cause any unsaved data to be " +
          " lost."
      else
        self.puts "Are you sure you want to quit? (yes/no)"
        self.print "> "
        input = self.gets.strip
        
        if self.token_to_boolean(input)
          self.dispatch_event Event.new :quit_application
        else
          self.puts "Please enter an action."
        end # if-else
      end # case args.first
    end # action :quit
  end # class ApplicationContext
end # module RoundTable::Controllers::Contexts
