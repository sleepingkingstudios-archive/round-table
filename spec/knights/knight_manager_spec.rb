# spec/knights/knight_manager_spec.rb

require 'spec_helper'
require 'knights/knight'
require 'knights/knight_manager'

describe RoundTable::Knights::KnightManager do
  __vendor_path__ = VENDOR_PATH
  before :all do
    Object.send :remove_const, :VENDOR_PATH
    Object.send :const_set, :VENDOR_PATH, SPEC_PATH
  end # before :all
  
  after :all do
    Object.send :remove_const, :VENDOR_PATH
    Object.send :const_set, :VENDOR_PATH, __vendor_path__
  end # after :all
  
  it "has a load path" do
    subject.load_path.should =~ /#{VENDOR_PATH}\/modules$/
    
    subject = described_class.new "/foo/bar"
    subject.load_path.should eq "/foo/bar"
  end # it has a load path
  
  it "can list modules in the load path" do
    subject.list.should include("Sir Not Appearing In This Film")
  end # it can list modules in the load path
  
  it "can load modules that exist" do
    subject.load("Sir Not Appearing In This Film").should_not be nil
  end # it can load modules ...
  
  it "cannot load modules that do not exist" do
    subject.load("The Green Knight").should be nil
  end # it cannot load ... that do not exist
end # describe KnightManager
