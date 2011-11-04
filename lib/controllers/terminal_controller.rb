# lib/controllers/terminal_controller.rb

require 'controllers/text_controller'

module RoundTable::Controllers
  class TerminalController < TextController
    def initialize
      super $stdin, $stdout
    end # method initialize
  end # class TerminalController
end # module RoundTable::Controllers
