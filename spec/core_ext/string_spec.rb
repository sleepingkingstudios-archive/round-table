# spec/core_ext/string.rb

require 'spec_helper'
require 'round_table'

describe String do
  let(:camel_string) { "IveGotALovelyBunchOfCoconutsDiddlyDum" }
  let(:space_string) { "I've got a lovely bunch of coconuts, diddly-dum."}
  let(:snake_string) { "ive_got_a_lovely_bunch_of_coconuts_diddly_dum" }
  
  describe "camelize method" do
    it { camel_string.camelize.should == camel_string }
    it { snake_string.camelize.should == camel_string }
    it { space_string.camelize.should == camel_string }
  end # describe camelize method
  
  describe "slugify method" do
    let(:slugified) { :ive_got_a_lovely_bunch_of_coconuts_diddly_dum }
    it { camel_string.slugify.should == slugified }
    it { snake_string.slugify.should == slugified }
    it { space_string.slugify.should == slugified }
  end # describe slugify method
  
  describe "snakify method" do
    it { camel_string.snakify.should == snake_string }
    it { snake_string.snakify.should == snake_string }
    it { space_string.snakify.should == snake_string }
  end # describe "snakify method"
end # describe String
