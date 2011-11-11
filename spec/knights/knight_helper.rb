# spec/knights/knight_helper.rb

require 'spec_helper'
require 'controllers/contexts/abstract_context'
require 'knights/knight'

shared_examples "a loadable \"knight\" module" do
  it "should be a knight" do
    described_class.should <= RoundTable::Knights::Knight
  end # it should be a knight
  
  it "can be instantiated without errors" do
    described_class.new
  end # it can be instantiated ...
  
  context "(has been instantiated)" do
    before :each do
      @knight = described_class.new
    end # before :each
    
    it "returns a valid context on build_context" do
      subject.build_context.should be_a RoundTable::Controllers::Contexts::AbstractContext
    end # it returns a valid context ...
    
    it "has a message method that returns a string" do
      subject.message.should be_a String
    end # it has a message method ...
  end # describe "has been instantiated"
end # a loadable ... module
