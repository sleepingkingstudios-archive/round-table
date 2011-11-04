# spec/debug/logger_spec.rb

require 'spec_helper'
require 'debug/logger'

describe RoundTable::Debug::Logger do
  include RoundTable::Debug
  
  ############RoundTable
  # Log Levels
  
  log_levels = %w(debug info warning error fatal panic)
  
  it "has log levels" do
    subject.class::LogLevels.should eq(log_levels)
    
    subject.log_level = log_levels[3]
    subject.log_level.should eq(log_levels[3])
    
    subject.log_level = 3
    subject.log_level.should eq(log_levels[3])
  end # it has log levels
  
  it "orders log levels" do
    log_levels.each_index do |index|
      level = log_levels[index]
      Logger::LogLevels.index(level).should eq(index)
      Logger.level_to_index(level).should eq(index)
    end # each_index
  end # it orders log levels
  
  it "can set log levels" do
    subject.log_level = 2 # set by name
    subject.log_level.should eq(log_levels[2])
    
    subject.log_level = log_levels[3] # set by string
    subject.log_level.should eq(log_levels[3])
    
    subject.log_level = log_levels[5].intern # set by symbol
    subject.log_level.should eq(log_levels[5])
  end # it can set log levels
  
  ##################
  # Logging Messages
  
  def mock_io_expecting(matcher)
    mock = double('mock_io')
    mock.should_receive(:puts).with(matcher)
    return mock
  end # method mock_io_expecting
  
  it "logs strings" do
    message = "This is a debug message."
    
    subject.output = mock_io_expecting(/#{message}/)
    subject.log(:debug, message)
  end # it logs strings
  
  it "can format the logged message" do
    message = "This is an info message."
    
    subject.format = "~~%m~~"
    subject.output = mock_io_expecting("~~#{message}~~")
    subject.log(:info, message)
  end # it can format the logged strings
  
  it "can include the log level in formatted messages" do
    level = :warning
    
    subject.format = "%L %m"
    subject.output = mock_io_expecting(/#{level.to_s.upcase}/)
    subject.log(level, "This is a warning message.")
    
    subject.format = "%l %m"
    subject.output = mock_io_expecting(/#{level.to_s}/i)
    subject.log(level, "This is a warning message.")
  end # it can include the log level
  
  #############################
  # Filtering Messages By Level
  
  def be_positive_but_less_than(number)
    simple_matcher("non-negative, but less than #{number}") { |actual| actual >= 0 && actual < number }
  end # matcher be_positive_but_less_than
  
  it "ignores messages with a level below the threshold" do
    threshold = 3
    threshold.should be_within_range(0, log_levels.count, :exclusive => true)
    
    mock_io = double('mock_io')
    mock_io.should_receive(:puts).never
    
    subject.log_level = threshold
    subject.output = mock_io
    ignored_levels = log_levels.slice(0, threshold)
    ignored_levels.each do |level|
      subject.log(level, "This is a(n) #{level} message.")
    end # each
  end # it ignores messages with a level below the threshold
  
  it "passes messages with a level at or above the threshold" do
    threshold = 2
    threshold.should be_within_range(0, log_levels.count, :exclusive => true)
    
    mock_io = double('mock_io')
    mock_io.should_receive(:puts).exactly(log_levels.count - threshold)
    
    subject.log_level = threshold
    subject.output = mock_io
    passed_levels = log_levels.slice(threshold, log_levels.count - 1)
    passed_levels.each do |level|
      subject.log(level, "This is a(n) #{level} message.")
    end # each
  end # it passes messages with a level at or above the threshold
end # spec Logger
