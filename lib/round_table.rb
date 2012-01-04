# lib/round_table.rb

LIBRARY_PATH = File.expand_path(File.dirname __FILE__)

module RoundTable
  def self.root
    File.expand_path(File.dirname __FILE__)
  end # module method root
end # module RoundTable

Kernel.puts "root = #{RoundTable.root}"

# Load in extensions to core classes.
Dir[File.join(RoundTable.root, "core_ext", "*.rb")].each { |f| require f }
