# main.rb

######################
# Set up the Load Path

$LOAD_PATH << (File.expand_path(File.dirname __FILE__) + "/lib")

require 'controllers/terminal_controller'

#####################################
# Instantiate Controller and Contexts

controller = RoundTable::Controllers::TerminalController.new

###############
# Begin Program
puts "Welcome to the Round Table interactive adventure platform"

controller.io_loop
