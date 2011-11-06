# lib/debug/file_logger.rb

require 'debug/debug'
require 'debug/logger'

module RoundTable::Debug
  class FileLogger < Logger
    def initialize(file_path)
      raise ArgumentError.new("expected a valid file path") unless file_path.is_a?(String) && File.exists?(file_path)
      @file_path = file_path
      
      super
    end # method initialize
    
  private
    def write_to_log(string)
      File.open @file_path, "a" do |file|
        file.write "#{string}\n"
      end # File.open
    end # method write_to_log(string)
  end # class FileLogger
end # module RoundTable::Debug
