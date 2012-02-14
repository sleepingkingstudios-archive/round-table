# spec/debug/logger_service_spec.rb

require 'spec_helper'
require 'debug/logger'
require 'debug/logger_service'

describe RoundTable::Debug::LoggerService do
  include RoundTable::Debug
  
  stored_logger = nil
  before :all do
    stored_logger = RoundTable::Debug::Logger::StoredLogger.logger
  end # before :all
  
  after :all do
    RoundTable::Debug::Logger::StoredLogger.logger = stored_logger
  end # after :all
  
  subject { Object.new.extend RoundTable::Debug::LoggerService }
  
  it "provides access to a logger" do
    subject.should respond_to(:logger)
    subject.logger.should be_a RoundTable::Debug::Logger
  end # it provides access to a logger
  
  it "can be given a new logger" do
    subject.should respond_to(:logger=)
    
    stored_logger = subject.logger
    
    custom_logger = RoundTable::Debug::Logger.new
    subject.logger = custom_logger
    subject.logger.should eq(custom_logger)
    
    subject.logger = stored_logger
  end # it can be given a new logger
  
  it "prints messages through its logger" do
    message = "This message was sent via the logging service."
    
    mock_io = double('mock_io')
    mock_io.should_receive(:puts).with(/#{message}/)
    
    stored_logger = subject.logger
    subject.logger = RoundTable::Debug::Logger.new :output => mock_io
    
    subject.instance_eval do
      logger.log(:info, message)
    end # module_eval
    
    subject.logger = stored_logger
  end # it prints messages through its logger
end # describe
