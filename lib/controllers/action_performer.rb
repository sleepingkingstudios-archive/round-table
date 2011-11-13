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
    end # class << self
    
    def execute_action(action, *tokens)
      method = "action_#{action.to_s.tr(" ", "_")}"
      logger.debug "#{self.class.to_s.gsub(/w+::/, "")}: executing action \"#{action}\", tokens = #{tokens.inspect}"
      
      if self.has_action? action
        self.send method, *tokens
      else
        self.missing_action action, *tokens
      end # if-else
    end # method execute_action
    
    def missing_action(action, *tokens)
      raise NoMethodError.new("undefined action `#{action}' for #{self}")
    end # method action_missing
    
    def has_action?(action)
      return self.respond_to? "action_#{action.to_s.tr(" ", "_")}"
    end # method has_action?
    
    def list_own_actions
      actions = Array.new
      self.methods.each do |method|
        method = method.to_s
        if method =~ /^action_/
          actions << method.gsub(/^action_/,'')
        end # if
      end # each
      actions.sort
    end # method list_own_actions
  end # class ActionPerformer
end # module RoundTable::Controllers
