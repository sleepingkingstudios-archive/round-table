# lib/scripts/scriptable.rb

require 'scripts/scripts'
require 'scripts/script_helper'

module RoundTable::Scripts
  module Scriptable
    def initialize_scripting(params = {})
      config = {
        :as => :script
      } # end config
      config.update(params) if params.is_a? Hash
      
      raise ArgumentError.new(":as must be a string or symbol") unless config[:as].is_a?(String) || config[:as].is_a?(Symbol)
      
      helper_name = config[:as].to_s.gsub(/^@+/,'')
      helper = ScriptHelper.new(self)
      self.instance_variable_set "@#{helper_name}", helper
      self.define_singleton_method helper_name, Proc.new {
        self.instance_variable_get "@#{helper_name}"
      } # end define_singleton_method
      
      @__script_helper__ = helper
    end # method initialize_scripting
    private :initialize_scripting
    
    def script_property(key, params = {})
      @__script_helper__.properties[key] = params
    end # method script_property
    private :script_property
    
    def script_function(key, function = nil, &block)
      raise ArgumentError.new("function must respond to :call") unless function.respond_to?(:call) || block_given?
      function ||= Proc.new &block
      @__script_helper__.functions[key] = function
    end # method script_function
    private :script_function
  end # module Scriptable
end # module RoundTable::Scripts