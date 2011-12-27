# lib/controllers/action_performer.rb

require 'controllers/controllers'
require 'debug/logger_service'

module RoundTable::Controllers
  class ActionPerformer
    include RoundTable::Debug::LoggerService
    
    class << self
      include RoundTable::Debug::LoggerService
      
      def action(name, &block)
        raise ArgumentError.new("expected a block") unless block_given?
        
        name = name.to_s.downcase.gsub(/[\s-]+/, '_').strip
        logger.debug "#{self.to_s.gsub(/\w+::/, "")}: defining action \"#{name}\""
        
        define_method "action_#{name}", block
      end # class method action
      
      def alias_action(new_name, old_name)
        alias_method :"action_alias_#{new_name}", :"action_#{old_name}"
      end # class method alias_action
    end # class << self
    
    def define_singleton_action(name, &block)
      raise ArgumentError.new("expected a block") unless block_given?
      
      name = name.to_s.downcase.gsub(/[\s-]+/, '_').strip
      logger.debug "#{self.to_s}: defining singleton action \"#{name}\""
      
      define_singleton_method "action_#{name}", block
    end # method define_singleton_action
    
    def execute_action(action, *tokens)
      logger.debug "#{self.class.to_s.gsub(/w+::/, "")}: executing action \"#{action}\", tokens = #{tokens.inspect}"
      
      if self.has_action? action
        method = "action_#{action.to_s.tr(" ", "_")}"
        self.send method, *tokens
      elsif self.has_alias? action
        method = "action_alias_#{action.to_s.tr(" ", "_")}"
        self.send method, *tokens
      else
        self.missing_action action, *tokens
      end # if-else
    end # method execute_action
    
    def missing_action(action, *tokens)
      raise NoMethodError.new("undefined action `#{action}' for #{self}")
    end # method action_missing
    
    def has_alias?(action)
      return self.respond_to? "action_alias_#{action.to_s.tr(" ", "_")}"
    end # method has_alias?
    
    def has_action?(action)
      return self.respond_to? "action_#{action.to_s.tr(" ", "_")}"
    end # method has_action?
    
    def list_own_aliases
      aliases = Array.new
      self.methods.each do |method|
        method = method.to_s
        if method =~ /^action_alias_/
          aliases << method.gsub(/^action_alias_/,'')
        end # if
      end # each
      aliases.sort
    end # method list_own_aliases
    
    def list_own_actions
      actions = Array.new
      self.methods.each do |method|
        method = method.to_s
        if method =~ /^action_/ && !(method =~ /^action_alias_/)
          actions << method.gsub(/^action_/,'')
        end # if
      end # each
      actions.sort
    end # method list_own_actions
  end # class ActionPerformer
end # module RoundTable::Controllers
