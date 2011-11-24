# lib/scripts/script_parser.rb

require 'treetop'
require 'scripts/scripts'
require 'scripts/script_helper'

Treetop.load 'lib/scripts/script_perilous'

module RoundTable::Scripts
  module Nodes
    include RoundTable::Scripts
    
    ###########################################################################
    # LITERAL NODES
    ###########################################################################
    
    module IntegerNode
      def call(recv = nil)
        self.text_value.to_i
      end # method call
    end # module IntegerNode
  
    module SymbolNode
      def call(recv = nil)
        self.text_value[1..-1].intern
      end # method call
    end # module SymbolNode
    
    module StringNode
      def call(recv = nil)
        self.elements.map{ |elem| elem.respond_to?(:call) ? elem.call(recv) : nil }.join
      end # method call
    end # module StringNode
    
    module StringSectionNode
      def call(recv = nil)
        self.text_value
      end # method call
    end # module StringSectionNode
    
    ###########################################################################
    # METHOD NODES
    ###########################################################################
    
    module ReceiverOperationNode
      def call(recv)
        recv = self.receiver.call(recv)
        
        # Kernel.puts "ReceiverOperationNode(): receiver = #{receiver}, messages = \"#{messages.text_value}\""
        
        messages.elements.each do |element|
          message = element.message
          # Kernel.puts "- element = #{element.text_value}, receiver = #{receiver}, message = #{message.text_value}"
          recv = message.call(recv)
        end # element
        
        recv
      end # method call
    end # module ReceiverOperationNode
    
    module PropertyAccessorNode
      def call(recv)
        property = self.property.text_value.intern
        # Kernel.puts "PropertyAccessorNode(): receiver = #{recv}, property = #{property}"
        
        recv.script.get(property)
      end # method call
    end # module PropertyAccessorNode
    
    module MethodCallNode
      def call(recv)
        message = self.message.text_value.intern
        
        # Kernel.puts "MethodCallNode(): subject = #{subject}, function = :#{function}, args = \"#{args.text_value}\""
        
        if args.empty?
          recv.script.call message
        else
          recv.script.call message, *(args.call(@env))
        end # if-else
      end # method call
    end # module MethodCallNode
    
    module ArgumentListNode
      def call(env)
        args = Array.new << arg
        
        # Kernel.puts "ArgumentListNode(): arg = \"#{arg.text_value}\", rest = \"#{rest.text_value}\""
        rest.elements.each do |elem|
          args << elem.elements.keep_if{ |elem| elem.nonterminal? }.first
        end # each
        
        args.map{ |arg| arg.call(@env) }
      end # method call
    end # module ArgumentListNode
    
    ###########################################################################
    # GLOBAL VARIABLES
    ###########################################################################
    
    module GlobalVariableNode
      def call(recv = nil)
        # Kernel.puts "GlobalVariableNode(): arg = #{self.identifier.text_value}, value = #{env.get_global self.identifier.text_value.intern}"
        key = self.identifier.text_value.intern
        ScriptHelper.class_eval {
          class_variable_get(:@@global_variables)[key]
        } # end class_eval
      end # method call
    end # module GlobalVariableNode
  end # module Nodes
end # module RoundTable::Scripts
