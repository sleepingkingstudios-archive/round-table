# spec/knights/knight_spec.rb

require 'spec_helper'
require 'knights/knight'

describe RoundTable::Knights::Knight do
  include RoundTable::Knights
  
  it "has a load path" do
    Knight::LOAD_PATH.should eq "modules"
  end # it has a load path
  
  #################
  # Loading Modules
  
  it "can load modules" do
    Knight.load("sir_not_appearing_in_this_film")
  end # it can load modules do
  
  it "tracks which modules have been loaded" do
    Knight.loaded_modules.should be_a Hash
    
    Knight.load("sir_not_appearing_in_this_film")
    Knight.loaded_modules["sir_not_appearing_in_this_film"].should be_a Knight
  end # it tracks which modules have been loaded
end # describe Knight
