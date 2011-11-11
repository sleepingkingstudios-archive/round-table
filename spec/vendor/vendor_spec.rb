# spec/vendor/vendor_spec.rb

require 'spec_helper'
require 'vendor/vendor'

describe RoundTable::Vendor do
  it "defines a VENDOR_PATH constant" do
    VENDOR_PATH.should =~ /\/vendor$/
  end # it defines a VENDOR_PATH constant
end # describe Vendor
