# lib/controllers/terminal_controller.rb

require 'controllers/text_controller'
require 'events/event_dispatcher'

module RoundTable::Controllers
  class TerminalController < TextController
    include RoundTable::Events::EventDispatcher
    
    def initialize(root_context, input = $stdin, output = $stdout)
      super
    end # method initialize
    
    def initialize_listeners
      @context_callbacks ||= Array.new
      
      callback = @root_context.add_listener :text_input, Proc.new { |event|
        event[:text] = self.gets
      }, :references => self # add_listener :text_input
      @context_callbacks << callback
      
      callback = @root_context.add_listener :text_output, Proc.new { |event|
        if event[:strip_whitespace]
          self.print event[:text]
        else
          self.puts event[:text]
        end # if-else
      }, :references => self # add_listener :text_output
      @context_callbacks << callback
      
      callback = @root_context.add_listener :quit_application, Proc.new { |event|
        self.kill!
      }, :references => self # add_listener :quit_application
    end # method initialize_listeners
    
    def remove_listeners
      return unless @context_callbacks.respond_to? :each
      @context_callbacks.each do |callback|
        @root_context.remove_listeners { |match| match == callback }
      end # each
    end # method remove_listeners
    
    def root_context=(context)
      self.remove_listeners
      
      super
      
      self.initialize_listeners
    end # method root_context=
    
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
      
        root_context.parse input
        
        self.print "> " unless self.kill?
      end # while loop
    end # method io_loop
  end # class TerminalController
end # module RoundTable::Controllers
