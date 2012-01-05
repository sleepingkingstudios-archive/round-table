# lib/round_table.rb

LIBRARY_PATH = File.expand_path(File.dirname __FILE__)

module RoundTable
  def self.root
    File.expand_path(File.dirname __FILE__).gsub(/lib[\w\/]+/, "")
  end # module method root
end # module RoundTable

# Load in extensions to core classes.
Dir[File.join(RoundTable.root, "core_ext", "*.rb")].each { |f| require f }
