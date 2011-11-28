# spec/errors/data_error_spec.rb

require 'spec_helper'
require 'errors/data_error'

describe RoundTable::Errors::DataError do
  before :each do
    @message = "location data must have a name"
    @error   = described_class.new(@message)
  end # before :each
  
  subject { @error }
  
  it { subject.should be_a StandardError }
  it { subject.to_s.should =~ /#{@message}/ }
  it { subject.inspect.should =~ /#{@message}/ }
  
  context "with source data" do
    before :each do
      @source = "This is sample source data.\n\nIt has several lines."
      @error.source = @source
    end # before :each
    
    subject { @error }
    
    it { subject.source.should == @source }
  end # context with source data
end # describe DataError
