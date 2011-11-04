# spec/debug/logger_service_spec.rb

require 'spec_helper'
require 'debug/logger'
require 'debug/logger_service'

RSpec::Matchers.define :be_a_logger do
  match do |actual|
    actual.is_a? PocketMonsters::Debug::Logger
  end # match
  
  failure_message_for_should do |actual|
    "expected #{actual.inspect} to be a logger"
  end # failure_message
  
  failure_message_for_should_not do |actual|
    "expected #{actual.inspect} not to be a logger"
  end # failure_message
end # define be_a_logger

describe PocketMonsters::Debug::LoggerService do
  include PocketMonsters::Debug
  
  subject { Object.new.extend LoggerService }
  
  it "provides access to a logger" do
    subject.should respond_to(:logger)
    subject.logger.should be_a_logger
  end # it provides access to a logger
  
  it "can be given a new logger" do
    subject.should respond_to(:logger=)
    
    custom_logger = Logger.new
    subject.logger = custom_logger
    subject.logger.should eq(custom_logger)
  end # it can be given a new logger
  
  it "prints messages through its logger" do
    message = "This message was sent via the logging service."
    
    mock_io = double('mock_io')
    mock_io.should_receive(:puts).with(/#{message}/)
    
    subject.logger = Logger.new :output => mock_io
    
    subject.instance_eval do
      logger.log(:info, message)
    end # module_eval
  end # it prints messages through its logger
end # describe
