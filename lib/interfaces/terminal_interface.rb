# lib/interfaces/terminal_interface.rb

require 'events/event_dispatcher'
require 'interfaces/interfaces'
require 'interfaces/text_interface'
require 'util/text_processor'

module RoundTable::Interfaces
  class TerminalInterface < TextInterface
    include RoundTable::Events::EventDispatcher
    include RoundTable::Util::TextProcessor
    
    def initialize(root_controller, input = $stdin, output = $stdout)
      super
    end # method initialize
    
    def initialize_listeners
      @context_callbacks ||= Array.new
      
      callback = @root_controller.add_listener :text_input, Proc.new { |event|
        event[:text] = self.gets
      }, :references => self # add_listener :text_input
      @context_callbacks << callback
      
      callback = @root_controller.add_listener :text_output, Proc.new { |event|
        self.print(self.break_text event[:text], 80)
      }, :references => self # add_listener :text_output
      @context_callbacks << callback
      
      callback = @root_controller.add_listener :quit_application, Proc.new { |event|
        self.kill!
      }, :references => self # add_listener :quit_application
    end # method initialize_listeners
    
    def remove_listeners
      return unless @context_callbacks.respond_to? :each
      @context_callbacks.each do |callback|
        @root_controller.remove_listeners { |match| match == callback }
      end # each
    end # method remove_listeners
    
    def root_controller=(context)
      self.remove_listeners
      
      super
      
      self.initialize_listeners
    end # method root_controller=
    
    ###################
    # Start the IO Loop
    
    def kill!
      @kill = true
    end # method kill!
    
    def kill?
      !!@kill
    end # method kill?
    
    def io_loop
      @kill = false
      self.print "> "
      
      while !self.kill? && (input = self.gets)
        input = input.strip
      
        root_controller.parse input
        
        self.print "> " unless self.kill?
      end # while loop
    end # method io_loop
  end # class TerminalInterface
end # module RoundTable::Interfaces
