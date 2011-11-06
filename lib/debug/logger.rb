# lib/debug/logger.rb

require 'debug/debug'

module RoundTable::Debug
  class Logger
    LogLevels = %w(debug info warning error fatal panic)
    
    ###########################################################################
    # CLASS METHODS
    ###########################################################################
    
    def self.level_to_index(level)
      Logger::LogLevels.index(level.to_s.downcase)
    end # class method level_to_index

    ###########################################################################    
    # INSTANCE METHODS
    ###########################################################################
    
    def initialize(params = {})
      config = {
        :format    => "%L %m",
        :log_level => "debug",
        :output    => $stderr
      } # end config
      config.update(params) if params.is_a? Hash
      
      self.format    = config[:format]
      self.log_level = config[:log_level]
      self.output    = config[:output]
    end # method initialize
    
    def method_missing(method, *args, &block)
      if Logger::LogLevels.include? method.to_s
        self.log(method, *args, &block)
      else
        super
      end # if-else
    end # method method_missing
    
    def to_s
      self.class.to_s
    end # method to_s
    
    ########################
    # Accessors and Mutators
    
    attr_accessor :format
    
    attr_reader :log_level
    def log_level=(level)
      # puts "#{self} log_level=(): level = #{level}, self.log_level = #{self.log_level}"
      @log_level = Logger::LogLevels[level] if level.is_a? Integer and (0...Logger::LogLevels.length).include? level
      @log_level = level.to_s       if Logger::LogLevels.include? level.to_s.downcase
      # puts ", final = #{self.log_level}"
    end # mutator log_level=
    
    attr_reader :output
    def output=(io)
      @output = io if io.respond_to? :puts
    end # mutator output=
    
    #################
    # Logging Strings
    
    def log(level, message)
      unless level.is_a? Integer then level = Logger.level_to_index(level) end
      
      # puts "#{self} log(): message = \"#{message}\", level = #{level}, self.log_level = #{Logger::LogLevels.index(self.log_level)}"
      
      return if level < Logger::LogLevels.index(self.log_level)
      
      str = String.new @format
      str.gsub!(/\%L/, Logger::LogLevels[level].to_s.upcase)
      str.gsub!(/\%l/, Logger::LogLevels[level].to_s)
      str.gsub!(/\%m/i, message)
      
      # puts "level = #{level}, message = #{message}, str = #{str}"
      
      write_to_log str
    end # method log
    
    def write_to_log(string)
      @output.puts string
    end # method write_to_log(string)
    private :write_to_log
  end # class Logger
end # module RoundTable::Debug
