# lib/controllers/contexts/application_context.rb

require 'controllers/contexts/contexts'
require 'controllers/contexts/base_context'
require 'knights/knight_manager'
require 'util/text_processor'

module RoundTable::Controllers::Contexts
  class ApplicationContext < BaseContext
    include RoundTable::Util
    
    def initialize
      @knights = RoundTable::Knights::KnightManager.new
      
      super
    end # method initialize
    
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
    
    action :load do |*args|
      case args.first
      when "help"
        self.puts "The \"load\" action is used to load modules. To load a" +
          " module, type \"load\" followed by the name of the module. For a " +
          " list of available modules, type \"load list\"."
      when "list"
        self.puts "The following modules are available: " +
          @knights.list.join(", ") + ". To load a module, type \"load\"" +
          " followed by the name of the module."
      else
        unless self.children.count == 0
          self.puts "There is already a module loaded. To load a new module," +
            " exit out of the current module and then type \"load\" followed" +
            " by the name of the module you wish to load."
          return
        end # unless
        
        name = args.join(" ")
        slug = TextProcessor.to_snake_case(name)
        full_name = slug.split("_").map { |word| word.capitalize }.join(" ")
        
        if @knights.modules.include? slug
          knight = @knights.modules[slug]
        else
          unless @knights.list.include? full_name
            self.puts "There is no module named \"#{full_name}\" in my load" +
              " path. For a list of available modules, type \"load list\"."
            return
          end # unless
        
          knight = @knights.load name
        end # if-else # module already loaded
        
        if knight.nil?
          self.puts "There was an error loading module #{name}."
          return
        end # if-else # loading error
        
        context = knight.build_context
        self.add_child context
        
        self.puts knight.message :initialize
      end # case args.first
    end # action :load
  end # class ApplicationContext
end # module RoundTable::Controllers::Contexts
