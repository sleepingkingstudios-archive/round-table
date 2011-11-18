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
      def call(env)
        self.text_value.to_i
      end # method call
    end # module IntegerNode
  
    module SymbolNode
      def call(env)
        self.text_value[1..-1].intern
      end # method call
    end # module SymbolNode
    
    module StringNode
      def call(env)
        self.elements.map{ |elem| elem.respond_to?(:call) ? elem.call(env) : nil }.join
      end # method call
    end # module StringNode
    
    module StringSectionNode
      def call(env)
        self.text_value
      end # method call
    end # module StringSectionNode
    
    ###########################################################################
    # METHOD NODES
    ###########################################################################
    
    module MethodCallNode
      def call(env, subject = nil)
        subject ||= env
        function = self.function.text_value.intern
        
        # Kernel.puts "MethodCallNode(): subject = #{subject}, function = :#{function}, args = \"#{args.text_value}\""
        
        if args.empty?
          subject.send function
        else
          subject.send function, *(args.call(@env))
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
    
=begin
    module ScriptNode
      def expressions
        ary = Array.new
        ary << self.expr
        
        unless rest.empty?
          ary += self.rest.script.expressions
        end # unless
        
        ary
      end # method expressions
      
      def call(env)
        # Kernel.puts "ScriptNode.call(): text = \"#{self.text_value}\", expression = \"#{self.expr.text_value}\", rest = \"#{self.rest.text_value}\"" +
        #   ", expressions = #{self.expressions.map{|elem| elem.text_value}}"
        
        value = nil
        self.expressions.each do |expr|
          value = expr.call(env)
        end # each
        return
      end # method call
    end # module ScriptNode

    ##################
    # Expression Nodes

    module ExpressionNode
      def call(env)
        self.elements.first.call(env)
      end # method call
    end # module ExpressionNode
  
    ################
    # Function Nodes
  
    module FunctionCallNode
      def call(env)
        subject = env
        function = self.function.text_value.intern
        argument_list = self.args.empty? ? [] : self.args.call(env)
        # Kernel.puts "FunctionCallNode: subject = \"#{subject}\", function = \"#{function}\", args = \"#{self.args.text_value}\""
        subject.send function, *(argument_list)
      end # method call
    end # module FunctionCallNode
    
    #############################
    # Property and Variable Nodes
    
    module ReadPropertyNode
      def call(env)
        subject = env
        property = self.property.text_value.intern
        if subject.respond_to? :get
          subject.get property
        else
          throw Kernel
          subject.send :"#{property}"
        end # if-else
      end # method call
    end # module ReadPropertyNode
    
    module WritePropertyNode
      def call(env)
        subject = env
        property = self.property.text_value.intern
        value = self.value.call(env)
        subject.set property, value
      end # method call
    end # module ReadPropertyNode
    
    module ReadGlobalVariableNode
      def call(env)
        property = self.property.text_value.intern
        env.get_global property
      end # method call
    end # module ReadGlobalVariableNode
    
    module WriteGlobalVariableNode
      def call(env)
        property = self.property.text_value.intern
        value = self.value.call(env)
        env.set_global property, value
      end # method call
    end # module WriteGlobalVariableNode
    
    ##############
    # Scalar Nodes
  
    module ScalarNode
      def call(env)
        self.elements.first.call(env)
      end # method call
    end # module ScalarNode
  
    ##############
    # String Nodes
  
    # module PlainStringNode
    #   def call(env)
    #     self.text_value
    #   end # method call
    # end # module PlainStringNode
=end
  end # module Nodes
end # module RoundTable::Scripts::ScriptPerilous