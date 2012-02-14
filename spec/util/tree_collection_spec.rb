# spec/util/tree_collection_spec.rb

require 'spec_helper'
require 'util/tree_collection'

describe RoundTable::Util::TreeCollection do
  let(:mock_tree_collection_class) {
    Class.new do
      include RoundTable::Util::TreeCollection
      
      def initialize(name)
        @name = name
        @parent = nil
        @children = []
      end # method initialize
      
      def to_s; @name.capitalize; end
      
      attr_accessor :name
    end # anonymous class
  } # end let :mock_tree_collection_class
  
  before :each do
    @weapons    = mock_tree_collection_class.new :weapons
    @swords     = mock_tree_collection_class.new :swords
    @daito      = mock_tree_collection_class.new :daito
    @shoto      = mock_tree_collection_class.new :shoto
    @fireworks  = mock_tree_collection_class.new :fireworks
  end # before :each
  
  def define_relationships
    @weapons.add_child @swords
    @swords.add_child @daito
    @swords.add_child @shoto
  end # function define_relationships
  
  ##############################
  # Adding and Removing Children
  
  it "can add child nodes" do
    @weapons.add_child @swords
    
    @swords.parent.should eq(@weapons)
    @weapons.include?(@swords).should be true
  end # it can add child nodes
  
  it "can remove child nodes" do
    define_relationships
    
    @weapons.remove_child @swords
    @swords.parent.should be nil
    @weapons.include?(@swords).should be false
  end # it can remove child nodes
  
  ########################
  # Accessors and Mutators
  
  it "has a protected parent attribute" do
    expect { @swords.parent = @weapons }.to raise_error
  end # it has a protected parent attribute
  
  it "has a child node" do
    define_relationships
    
    @weapons.child.should be @swords
    @swords.child.should be @shoto
    @shoto.child.should be nil
  end # it has a child node
  
  it "has a leaf node" do
    define_relationships
    
    @weapons.leaf.should be @shoto
    @swords.leaf.should be @shoto
    @daito.leaf.should be @daito
    @shoto.leaf.should be @shoto
    @fireworks.leaf.should be @fireworks
  end # it has a leaf node
  
  it "has a root node" do
    define_relationships
    
    @weapons.root.should be @weapons
    @swords.root.should be @weapons
    @daito.root.should be @weapons
    @shoto.root.should be @weapons
    @fireworks.root.should be @fireworks
  end # it has a root node
  
  #################
  # Utility Methods
  
  it "can be a root node" do
    define_relationships
    
    @weapons.root?.should be true
    @swords.root?.should be false
    @daito.root?.should be false
    @daito.root?.should be false
    @fireworks.root?.should be true
  end # it has a root node
  
  it "can be a leaf node" do
    define_relationships
    
    @weapons.leaf?.should be false
    @swords.leaf?.should be false
    @daito.leaf?.should be true
    @shoto.leaf?.should be true
    @fireworks.leaf?.should be true
  end # it can be a leaf node
  
  it "can count its child nodes" do
    define_relationships
    
    @weapons.count.should be 1
    @swords.count.should be 2
    @daito.count.should be 0
    @shoto.count.should be 0
    @fireworks.count.should be 0
  end # it can count its child nodes
  
  it "can check if another node is its child" do
    define_relationships
    
    @weapons.include?(@swords).should be true
    @weapons.include?(@daito).should be false
    @swords.include?(@weapons).should be false
    @swords.include?(@daito).should be true
  end # it can check if another node is its child
  
  it "can find the index of a child node" do
    define_relationships
    
    @weapons.index(@swords).should be 0
    @weapons.index(@daito).should be nil
    @swords.index(@daito).should be 0
    @swords.index(@shoto).should be 1
  end # it can find the index of a child node
  
end # describe TreeCollection
