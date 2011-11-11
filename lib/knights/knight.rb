# lib/knights/knight.rb

require 'controllers/contexts/abstract_context'
require 'knights/knights'
require 'vendor/modules'
require 'util/text_processor'

module RoundTable::Knights
  class Knight
    LOAD_PATH = "modules"
    
    @@modules = Hash.new
    
    class << self
      include RoundTable::Util
      
      def load(name)
        slug = TextProcessor.to_snake_case name
        name = TextProcessor.to_camel_case name
        
        return @@modules[slug] if @@modules[slug].is_a? Knight
        
        require "#{Knight::LOAD_PATH}/#{slug}/init"
        
        klass = RoundTable::Vendor::Modules.const_get(name)::Knights.const_get(name)
        
        @@modules[slug] = klass.new
      end # class method load
      
      def loaded_modules
        @@modules
      end # class method loaded_modules
    end # class << self
    
    def build_context
      RoundTable::Controllers::Contexts::AbstractContext.new
    end # method build_context
  end # class Knight
end # module RoundTable::Knights
