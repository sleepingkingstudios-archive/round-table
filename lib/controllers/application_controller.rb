# lib/controllers/application_controller.rb

require 'controllers/controllers'
require 'controllers/base_controller'
require 'knights/knight'
require 'knights/knight_manager'
require 'util/text_processor'

module RoundTable::Controllers
  class ApplicationController < BaseController
    include RoundTable::Knights
    include RoundTable::Util
    
    def initialize
      @knights = KnightManager.new
      @current_knight = nil
      
      super
    end # method initialize
    
    action :quit do |*args|
      case args.first
      when "help"
        self.puts "The \"quit\" action exits the application. The user is" +
          " prompted for a confirmation. To skip the confirmation, type" +
          " \"quit force\", however, this may cause any unsaved data to be " +
          " lost."
      when "force"
        knight = @current_knight || Knight.new
        self.puts knight.message :quit
        self.dispatch_event Event.new :quit_application
      else
        self.puts "Are you sure you want to quit? (yes/no)"
        self.print "> "
        input = self.gets.strip
        
        knight = @current_knight || Knight.new
        
        if self.token_to_boolean(input)
          self.puts knight.message :quit
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
        unless @current_knight.nil?
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
        
        @current_knight = knight
        
        controller = knight.controller
        self.add_child controller
        
        self.puts knight.message :load
      end # case args.first
    end # action :load
  end # class ApplicationController
end # module RoundTable::Controllers
