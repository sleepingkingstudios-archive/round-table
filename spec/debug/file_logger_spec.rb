# spec/debug/file_logger_spec.rb

require 'spec_helper'
require 'debug/file_logger'

describe RoundTable::Debug::FileLogger do
  before :each do
    @log_path = "#{File.dirname __FILE__}/log_tmp.txt"
    @log_file = File.new @log_path, "w+"
  end # before :each
  
  after :each do
    @log_file.close
    File.delete @log_path
  end # after :each
  
  it "must be passed a log file in the constructor" do
    expect { RoundTable::Debug::FileLogger.new }.to raise_error ArgumentError
    expect { RoundTable::Debug::FileLogger.new nil }.to raise_error ArgumentError
    RoundTable::Debug::FileLogger.new @log_path
  end # it must be passed a log file ...
  
  it "writes to a log file" do
    debug_message = "This is a debug message."
    info_message  = "This is an info message."
    warn_message  = "This is a warning message."
    subject = RoundTable::Debug::FileLogger.new @log_path
    
    subject.debug   debug_message
    subject.info    info_message
    subject.warning warn_message
    
    file_contents = @log_file.read
    
    file_contents.should =~ /#{debug_message}/
    file_contents.should =~ /#{info_message}/
    file_contents.should =~ /#{warn_message}/
  end # it writes to a log file
end # describe FileLogger
