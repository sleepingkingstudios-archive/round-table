# lib/controllers/contexts/action_performer.rb

require 'controllers/contexts/contexts'
require 'debug/logger_service'

module RoundTable::Controllers::Contexts
  class ActionPerformer
    include RoundTable::Debug::LoggerService
    
    class << self
      include RoundTable::Debug::LoggerService
      
      def action(name, &block)
        raise ArgumentError.new("expected a block") unless block_given?
        
        name = name.to_s.downcase.strip
        logger.debug "#{self.to_s.gsub(/\w+::/, "")}: defining action \"#{name}\", block = #{block}"
        
        define_method "action_#{name}", block
      end # class method action
    end # class << self
    
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
end # module RoundTable::Controllers::Contexts
