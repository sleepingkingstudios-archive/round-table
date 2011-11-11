# spec/spec_helper.rb

require 'round_table'
require 'debug/file_logger'
require 'debug/logger_service'

SPEC_PATH = File.expand_path(File.dirname __FILE__)

module RoundTable
  module Mock
    
  end # module Mock
end # module RoundTable

################
# Set up Logging

include RoundTable::Debug::LoggerService

file_path = "#{Dir.pwd}/log/log_spec.txt"
File.new(file_path, "w+") unless File.exists?(file_path)
File.open(file_path, "w+") { |file| file.truncate(0) }

logger = RoundTable::Debug::FileLogger.new file_path
RoundTable::Debug::LoggerService::StoredLogger.logger = logger

logger.format = "\n\n%m"
logger.info "Running spec_helper..."
logger.format = "%L %m"

###########################################################################
# CUSTOM MATCHERS
###########################################################################

RSpec::Matchers.define :be_within_range do |min, max, params = {}|
  config = { :exclusive => false }
  config.update(params) if params.is_a? Hash
  
  match do |value|
    range = config[:exclusive] ? min...max : min..max
    range.include? value
  end # match
  
  failure_message_for_should do |value|
    "expected value #{value.inspect} to be between #{min} and #{max}"
  end # failure_message
  
  failure_message_for_should_not do |value|
    "expected value #{value.inspect} not to be between #{min} and #{max}"
  end # failure_message
end # define be_within_range
