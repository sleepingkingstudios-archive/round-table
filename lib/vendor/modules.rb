# lib/vendor/modules.rb

require 'vendor/vendor'

module RoundTable::Vendor
  module Modules; end
end # module RoundTable::Vendor

# This enables easier access to modules from their lib files, e.g. MyModule
# instead of the full RoundTable::Vendor::Modules::MyModule.
include RoundTable::Vendor::Modules
