# lib/knights/knight_manager.rb

require 'knights/knights'
require 'knights/knight'
require 'util/text_processor'
require 'vendor/modules'

module RoundTable::Knights
  class KnightManager
    include RoundTable::Util
    
    def initialize(load_path = "#{VENDOR_PATH}/modules")
      @load_path = load_path
      
      @modules = Hash.new
    end # method initialize
    
    attr_reader :load_path, :modules
    
    def list
      Dir.glob("#{@load_path}/*").map { |path|
        next nil unless File.directory? path
        TextProcessor.to_snake_case(path.gsub(/\w+\/|\//, "")).split("_").map { |dir_name|
          dir_name.capitalize
        }.join(" ")
      }
    end # method list
    
    def load(name)
      slug = TextProcessor.to_snake_case name
      name = TextProcessor.to_camel_case name
      
      return @modules[slug] if @modules[slug].is_a? Knight
      
      # check if the module directory exists
      directory_path = "#{@load_path}/#{slug}"
      return nil unless File.directory? directory_path
      
      # check if the module has an init.rb file
      return nil unless File.file? "#{directory_path}/init.rb"
      require "#{directory_path}/init"
      
      # check if a Ruby module has been added to scope
      knight_module = RoundTable::Vendor::Modules.const_get name
      return nil unless knight_module.is_a? Module
      
      # retrieve the knight object
      knight = knight_module.knight
      return nil unless knight.is_a? Knight
      
      @modules[slug] = knight
      knight
    end # method load
  end # class KnightManager
end # module RoundTable::Knights