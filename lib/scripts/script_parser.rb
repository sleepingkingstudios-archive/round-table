# lib/scripts/script_parser.rb

require 'treetop'
require 'scripts/scripts'

Treetop.load 'lib/scripts/script_perilous'

module RoundTable::Scripts
  module Nodes
    module ScriptNode
      def call(env = nil)
        value = nil
        self.elements.each { |elem|
          value = elem.call(env)
        } # end each
        value
      end # method call
    end # module ScriptNode

    ##################
    # Expression Nodes

    module ExpressionNode
      def call(env = nil)
        self.elements.first.call(env)
      end # method call
    end # module ExpressionNode
  
    ################
    # Function Nodes
  
    module FunctionCallNode
      def call(env = nil)
        subject = env
        function = self.function.text_value.intern
        argument_list = self.args.empty? ? [] : self.args.call(env)
        # Kernel.puts "FunctionCallNode: subject = \"#{subject}\", function = \"#{function}\", args = \"#{self.args.text_value}\""
        subject.send function, *(argument_list)
      end # method call
    end # module FunctionCallNode
    
    module ArgumentListNode
      def call(env = nil)
        args = [self.first.call(env)]
        
        unless rest.nil? || (elems = rest.elements).empty?
          elems = rest.elements
          args += elems.first.args.call(env)
        end # unless
        
        # Kernel.puts "processing ArgumentListNode, raw = \"#{self.text_value}\", args = #{args}}"
        args
      end # method call
    end # module ArgumentListNode
    
    #############################
    # Property and Variable Nodes
    
    module ReadPropertyNode
      def call(env = nil)
        subject = env
        property = self.text_value.intern
        subject.get property
      end # method call
    end # module ReadPropertyNode
    
    module WritePropertyNode
      def call(env = nil)
        subject = env
        property = self.property.text_value.intern
        value = self.value.call(env)
        subject.set property, value
      end # method call
    end # module ReadPropertyNode
    
    module ReadGlobalVariableNode
      def call(env = nil)
        property = self.property.text_value.intern
        env.get_global property
      end # method call
    end # module ReadGlobalVariableNode
    
    module WriteGlobalVariableNode
      def call(env = nil)
        property = self.property.text_value.intern
        value = self.value.call(env)
        env.set_global property, value
      end # method call
    end # module WriteGlobalVariableNode
    
    ##############
    # Scalar Nodes
  
    module ScalarNode
      def call(env = nil)
        self.elements.first.call(env)
      end # method call
    end # module ScalarNode
  
    module IntegerNode
      def call(env = nil)
        self.text_value.to_i
      end # method call
    end # module IntegerNode
  
    module SymbolNode
      def call(env = nil)
        self.text_value[1..-1].intern
      end # method call
    end # module SymbolNode
  
    ##############
    # String Nodes
  
    module StringNode
      def call(env = nil)
        self.elements.map{ |elem| elem.respond_to?(:call) ? elem.call(env) : nil }.join
      end # method call
    end # module StringNode
  
    module PlainStringNode
      def call(env = nil)
        self.text_value
      end # method call
    end # module PlainStringNode
  end # module Nodes
end # module RoundTable::Scripts::ScriptPerilous