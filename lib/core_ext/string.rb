# lib/core_ext/string.rb

=begin DESCRIPTION
  Convenience methods added to String.
  
  This file is automatically required from lib/round_table.rb.
=end

class String
  def camelize
    self.split(/[\s_-]+/).
      inject("") { |memo, str| "#{memo}#{str.slice!(0).upcase}#{str}" }.
      gsub(/[^a-zA-Z0-9_]/, '')
  end # method camelize
  
  def slugify
    self.snakify.intern
  end # method slugify
  
  def snakify
    self.gsub(/([A-Z]+)([A-Z][a-z])/,'\1_\2').
      gsub(/([a-z\d])([A-Z])/,'\1_\2').
      tr("- ", "_").
      gsub(/[^a-zA-Z0-9_]/, '').
      downcase
  end # method snakify
end # class String
