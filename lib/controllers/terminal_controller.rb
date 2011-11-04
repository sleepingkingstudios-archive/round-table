# lib/controllers/terminal_controller.rb

require 'controllers/text_controller'

module RoundTable::Controllers
  class TerminalController < TextController
    def initialize(input = $stdin, output = $stdout)
      super
    end # method initialize
    
    ###################
    # Start the IO Loop
    
    def io_loop
      self.print "> "
      
      while input = self.gets
        break if input =~ /quit/i
        
        self.puts "You said \"#{input.chomp}\""
        self.print "> "
      end # while loop
    end # method io_loop
  end # class TerminalController
end # module RoundTable::Controllers
