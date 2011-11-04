# lib/debug/logger_service.rb

require 'debug/debug'
require 'debug/logger'

module PocketMonsters::Debug
  module LoggerService
    def logger
      StoredLogger.logger
    end # method logger

    def logger=(logger)
      StoredLogger.logger = logger
    end # method logger=
    
    class StoredLogger
      def self.logger
        @logger
      end # class accessor logger
    
      def self.logger=(logger)
        @logger = logger if logger.is_a? Logger
      end # module mutator logger=
    
      self.logger = Logger.new
    end # class StoredLogger
  end # module LoggerService
end # module PocketMonsters::Debug
