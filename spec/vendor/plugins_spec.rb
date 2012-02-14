# spec/vendor/plugins_spec.rb

require 'spec_helper'
require 'vendor/plugins'

describe RoundTable::Vendor::Plugins do
  it { RoundTable::Vendor.const_defined?(:Plugins).should be true }
  it { RoundTable::Vendor.const_get(:Plugins).should be_a Module }
end # describe Plugins
