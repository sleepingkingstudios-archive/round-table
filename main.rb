# main.rb

######################
# Set up the Load Path

$LOAD_PATH << (File.expand_path(File.dirname __FILE__) + "/lib")

require 'controllers/terminal_controller'
require 'controllers/contexts/abstract_context'
require 'debug/file_logger'
require 'debug/logger_service'

################
# Set up Logging

include RoundTable::Debug::LoggerService

file_path = "#{Dir.pwd}/log/log_production.txt"
File.new(file_path, "w+") unless File.exists?(file_path)

logger = RoundTable::Debug::FileLogger.new file_path
RoundTable::Debug::LoggerService::StoredLogger.logger = logger

logger.format = "\n\n%m"
logger.info "Running Round Table..."
logger.format = "%L %m"

#####################################
# Instantiate Controller and Contexts

context = RoundTable::Controllers::Contexts::AbstractContext.new
controller = RoundTable::Controllers::TerminalController.new context

###############
# Begin Program
puts "Welcome to the Round Table interactive adventure platform"

controller.io_loop
