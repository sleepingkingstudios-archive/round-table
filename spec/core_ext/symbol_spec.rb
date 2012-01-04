# lib/core_ext/symbol_spec.rb

require 'spec_helper'

describe Symbol do
  subject { :"hi, I'm @ symbol" }
  
  it { subject.slugify.should == subject }
end # describe Symbol