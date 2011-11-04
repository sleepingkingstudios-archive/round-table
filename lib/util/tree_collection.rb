# lib/util/tree_collection.rb

require 'util/util'

module RoundTable::Util
  module TreeCollection
    
    ##############################
    # Adding and Removing Children
    
    def add_child(node)
      return unless node.is_a? TreeCollection
      @children.push(node)
      node.parent = self
    end # method add_child
    
    def remove_child(node)
      return unless self.include? node
      node.parent = nil
      @children.delete(node)
    end # method remove_child
    
    ########################
    # Accessors and Mutators
    
    def child
      @children.last
    end # accessor child
    
    attr_reader :children
    
    def leaf
      self.leaf? ? self : self.child.leaf
    end # accessor leaf
    
    attr_reader :parent
    
    def parent=(node)
      return unless node.is_a? TreeCollection or node.nil?
      @parent = node
    end # mutator parent=
    protected :parent=
    
    def root
      self.root? ? self : self.parent.root
    end # accessor root
    
    #################
    # Utility Methods
    
    def count
      @children.count
    end # method count
    
    def include?(node)
      @children.include? node
    end # method include?
    
    def index(node)
      @children.index node
    end # method index
    
    def leaf?
      @children.count == 0
    end # method leaf?
    
    def root?
      self.parent.nil?
    end # method root
  end # module TreeCollection
end # module RoundTable::Util
