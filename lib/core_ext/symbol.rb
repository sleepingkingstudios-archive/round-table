# lib/core_ext/symbol.rb

=begin DESCRIPTION
  Convenience methods added to Symbol.
  
  This file is automatically required from lib/round_table.rb.
=end

class Symbol
  def slugify
    self # for String compatibility
  end # method slugify
end # class Symbol
