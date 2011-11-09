# main.rb

######################
# Set up the Load Path

current_path = File.expand_path(File.dirname __FILE__)
$LOAD_PATH << "#{current_path}/lib" << "#{current_path}/vendor"

################
# Set up Logging

require 'debug/file_logger'
require 'debug/logger_service'

include RoundTable::Debug::LoggerService

file_path = "#{Dir.pwd}/log/log_production.txt"
File.new(file_path, "w+") unless File.exists?(file_path)

logger = RoundTable::Debug::FileLogger.new file_path
RoundTable::Debug::LoggerService::StoredLogger.logger = logger

logger.format = "\n\n%m"
logger.info "Running Round Table..."
logger.format = "%L %m"

###################
# Require Resources

require 'controllers/terminal_controller'
require 'controllers/contexts/application_context'

#####################################
# Instantiate Controller and Contexts

context = RoundTable::Controllers::Contexts::ApplicationContext.new
controller = RoundTable::Controllers::TerminalController.new context

###############
# Begin Program
puts "Welcome to the Round Table interactive adventure platform"

controller.io_loop
