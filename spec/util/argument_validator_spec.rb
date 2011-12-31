# spec/util/argument_validator_spec.rb

require 'spec_helper'
require 'util/argument_validator'

describe RoundTable::Util::ArgumentValidator do
  include RoundTable::Util
  
  before :each do
    @validator = Object.new.extend ArgumentValidator
  end # before :each
  subject { @validator }
  
  let(:name) { "my_value" }
  
  describe "expects 1..2 arguments" do
    let(:message) { /wrong number of arguments/i }
    
    it { expect { subject.validate_argument }.to raise_error ArgumentError, message }
    it { expect { subject.validate_argument nil }.not_to raise_error ArgumentError, message }
    it { expect { subject.validate_argument nil, nil }.not_to raise_error ArgumentError, message }
    it { expect { subject.validate_argument nil, nil, nil }.to raise_error ArgumentError, message }
  end # describe expects 1..2 arguments
  
  describe "expects second argument to be Hash or nil" do
    let(:message) { /expected params to be Hash/i }
    
    it { expect { subject.validate_argument :sym, :sym }.to raise_error ArgumentError, message }
    it { expect { subject.validate_argument :sym, Hash.new }.not_to raise_error ArgumentError, message }
    it { expect { subject.validate_argument :sym }.not_to raise_error ArgumentError, message }
  end # describe expects second argument to be Hash or nil
  
  describe "validates non-nil values" do
    let(:message) { /not to be nil/i }
    
    it { expect { subject.validate_argument nil }.to raise_error ArgumentError, message }
    it { expect { subject.validate_argument :sym }.not_to raise_error ArgumentError, message }
    it { expect { subject.validate_argument nil, :allow_nil? => true }.not_to raise_error ArgumentError }
    
    it { expect { subject.validate_argument nil, :as => name }.to raise_error ArgumentError, /#{name}/ }
  end # describe validates non-nil values
  
  describe "validates nil values" do
    let(:message) { /to be nil/i }
    
    it { expect { subject.validate_argument :sym, :nil? => true }.to raise_error ArgumentError, message }
    it { expect { subject.validate_argument nil, :nil? => true }.not_to raise_error ArgumentError }
    
    it { expect { subject.validate_argument :sym, :nil? => true, :as => name }.to raise_error ArgumentError, /#{name}/ }
  end # describe validates nil values
  
  describe "validates single type" do
    let(:type) { Symbol }
    let(:message) { /to be #{type}/i }
    
    it { expect { subject.validate_argument ["ary"], :type => type }.to raise_error ArgumentError, message }
    it { expect { subject.validate_argument :sym, :type => type }.not_to raise_error ArgumentError }
    
    it { expect { subject.validate_argument ["ary"], :type => type, :as => name }.to raise_error ArgumentError, /#{name}/ }
  end # describe validates single type
  
  describe "validates array of types" do
    let(:types) { [ String, Symbol, Fixnum ] }
    let(:message) { /to be #{types.join(" or ")}/i }
    
    it { expect { subject.validate_argument ["ary"], :type => types }.to raise_error ArgumentError, message }
    it { expect { subject.validate_argument "str", :type => types }.not_to raise_error ArgumentError }
    it { expect { subject.validate_argument :sym, :type => types }.not_to raise_error ArgumentError }
    it { expect { subject.validate_argument 101, :type => types }.not_to raise_error ArgumentError }
    
    it { expect { subject.validate_argument ["ary"], :type => types, :as => name }.to raise_error ArgumentError, /#{name}/ }
  end # describe validates array of types
end # describe ArgumentValidator
