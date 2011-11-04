# lib/debug/logger.rb

require 'debug/debug'

module RoundTable::Debug
  class Logger
    LogLevels = %w(debug info warning error fatal panic)
    
    ###########################################################################
    # CLASS METHODS
    ###########################################################################
    
    def self.level_to_index(level)
      LogLevels.index(level.to_s.downcase)
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
    
    ########################
    # Accessors and Mutators
    
    attr_accessor :format
    
    attr_reader :log_level
    def log_level=(level)
      # print "#{self} log_level=(): level = #{level}, self.log_level = #{self.log_level}"
      @log_level = LogLevels[level] if level.is_a? Integer and (0...LogLevels.length).include? level
      @log_level = level.to_s       if LogLevels.include? level.to_s.downcase
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
      
      # puts "\n#{self} log(): message = \"#{message}\", level = #{level}, self.log_level = #{LogLevels.index(self.log_level)}\n"
      
      return if level < LogLevels.index(self.log_level)
      
      str = @format
      str.gsub!(/\%L/, LogLevels[level].to_s.upcase)
      str.gsub!(/\%l/, LogLevels[level].to_s)
      str.gsub!(/\%m/i, message)
      
      @output.puts str
    end # method log
  end # class Logger
end # module RoundTable::Debug
