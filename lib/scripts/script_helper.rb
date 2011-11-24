# lib/scripts/script_helper.rb

require 'scripts/scripts'
require 'scripts/scriptable'

module RoundTable::Scripts
  class ScriptHelper
    def initialize(parent)
      raise ArgumentError.new("parent must implement RoundTable::Scripts::Scriptable") unless parent.is_a?(Scriptable)
      @parent = parent
      
      @properties = Hash.new
      @functions  = Hash.new
      
      @@global_variables ||= Hash.new
      @@global_functions ||= Hash.new
    end # method initialize
    
    attr_accessor :properties, :functions
    
    ###################################
    # Properties and Instance Functions
    
    def get(key)
      # Kernel.puts "get(): key = #{key}, #{@properties[key]}"
      raise NoMethodError.new("property #{key} has not been registered for script access") unless @properties.include?(key)
      raise NoMethodError.new("script read access has not been enabled for property #{key}") if @properties[key][:only] == :write
      @parent.send :"#{key}"
    end # method get
    
    def set(key, value)
      # Kernel.puts "set(): key = #{key}, value = #{value}"
      raise NoMethodError.new("property #{key} has not been registered for script access") unless @properties.include?(key)
      raise NoMethodError.new("script write access has not been enabled for property #{key}") if @properties[key][:only] == :read
      @parent.send :"#{key}=", value
    end # method set
    
    def call(key, *args)
      raise NoMethodError.new("function #{key} has not been registered for script access") unless @functions.include?(key)
      raise NoMethodError.new("function #{key} does not respond to :call") unless @functions[key].respond_to? :call
      @functions[key].call(*args)
    end # method call
    
    ################################
    # Global Variables and Functions
    
    def get_global(key)
      @@global_variables[key]
    end # method get_global
    
    def set_global(key, value)
      @@global_variables[key] = value
    end # method set_global
    
    # def define_global(key, function)
    #   raise ArgumentError.new("function must respond to :call") unless function.respond_to? :call
    #   @@global_functions[key] = function
    # end # method define_global
    # 
    # def send_global(key, *args)
    #   raise NoMethodError.new("global function #{key} has not been defined") unless @@global_functions.include?(key)
    #   raise NoMethodError.new("global function #{key} does not respond to :call") unless @@global_functions[key].respond_to? :call
    #   @@global_functions[key].call(*args)
    # end # method send_global
  end # class ScriptHelper
end # module RoundTable::Scripts
