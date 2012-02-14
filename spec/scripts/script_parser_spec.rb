# spec/scripts/script_parser_spec.rb

require 'spec_helper'
require 'scripts/scriptable'
require 'scripts/script_parser'

describe RoundTable::Scripts::ScriptParser do
  pending "Not sure whether this will be implemented or not..."
=begin
  def mock_scriptable(&block)
    recv = Object.new
    recv.extend Scriptable
    recv.instance_eval do initialize_scripting end
    recv.instance_eval &block if block_given?
    recv
  end # method mock_scriptable
  
  before :each do
    @env = mock('callable')
    @env.stub(:send)
    
    @receiver = mock_scriptable()
    @receiver.script.class.class_eval do
      class_variable_set :@@global_variables, Hash.new
      class_variable_set :@@global_functions, Hash.new
    end # class_eval
  end # before :each
  
  #############################################################################
  # LITERALS
  #############################################################################
  
  it "can parse integer literals" do
    [0, 1, -1, 10, 1337].each do |integer|
      [:integer, :literal, :term, :expression].each do |root|
        # Kernel.puts "parsing integer \":#{integer}\" as #{root}..."
        subject.parse("#{integer}", :root => root).call(@receiver).should == integer
      end # each root
    end # each
  end # it can parse integer literals
  
  it "can parse symbol literals" do
    [:foo, :bar, :_baz, :__bizzle__, :wibble_wobble].each do |symbol|
      [:symbol, :literal, :term, :expression].each do |root|
        # Kernel.puts "parsing symbol \":#{symbol}\" as #{root}..."
        subject.parse(":#{symbol}", :root => root).call(@receiver).should == symbol
      end # each root
    end # each
  end # it can parse symbol literals
  
  it "can parse plain string literals" do
    [ "Hello, world!",
      "This is a \\\"test\\\" string\n",
      "\t- I hope\nyou\nlike it!\r\n",
      "Now is the the winter of our discontent, turned glorious summer by" +
        " this son of York",
    ].each do |string|
      [:string, :literal, :term, :expression].each do |root|
        # Kernel.puts "parsing string \":#{string}\" as #{root}..."
        subject.parse("\"#{string}\"", :root => root).call(@receiver).should == string
      end # each root
    end # each
  end # it can parse plain string literals
  
  #############################################################################
  # TERMS AND EXPRESSIONS
  #############################################################################
  
  it "can parse identifiers" do
    ["foo", "_bar", "BAZ", "__bizzle__", "wibble_wobble"].each do |identifier|
      subject.parse(identifier, :root => :identifier).text_value.should == identifier
    end # each
    
    ["99bottles", "of beer", "@on_the_wall", ":takeOneDown", "[pass it around]"].each do |identifier|
      subject.parse(identifier, :root => :identifier).should be nil
    end # each
  end # it can parse identifiers
  
  it "can parse method identifiers" do
    ["foo=", "_bar=", "[]", "[]="].each do |identifier|
      subject.parse(identifier, :root => :method_identifier).text_value.should == identifier
    end # each
  end # it can parse method_identifiers
  
  it "can get global variables" do
    @receiver.script.set_global :foo, "FOO"
    @receiver.script.set_global :bar, "BAR"
    @receiver.script.set_global :baz, "BAZ"
    
    [:foo, :bar, :baz].each do |global|
      [:global_variable, :term, :expression].each do |root|
        string = "$#{global.to_s}"
        # Kernel.puts "parsing global variable \":#{string}\" as #{root}..."
        subject.parse(string, :root => root).call(@receiver).should == global.to_s.upcase
      end # each
    end # method each
  end # it can get global variables
  
  #############################################################################
  # METHODS
  #############################################################################
  
  it "can parse argument lists" do
    { "0" => [0],
      "0, :foo, \"bar\"" => [0, :foo, "bar"]
    }.each do |string, ary|
      subject.parse(string, :root => :argument_list).call(@env).should == ary
    end # each
  end # it can parse argument lists
  
  it "can parse method calls" do
    [ { :string => "foo()",
        :message => :foo,
        :args => [],
        :result => "FOO" },
      { :string => "baz(0, :foo, \"bar\")",
        :message => :baz,
        :args => [0, :foo, "bar"],
        :result => :too_strange },
      { :string => "[]=(:wibble, :wobble)",
        :message => :[]=,
        :args => [:wibble, :wobble],
        :result => :wobble }
    ].each do |method_call|
      @receiver.instance_eval {
        script_function method_call[:message] { method_call[:result] }
      } # end instance_eval
      
      [:method_call].each do |root|
        # Kernel.puts "parsing operation \":#{method_call[:string]}\" as #{root}..."
        args = [method_call[:message]] + method_call[:args]
        subject.parse(method_call[:string], :root => root).call(@receiver).should == method_call[:result]
      end # each root
    end # each
  end # it can parse method calls
  
  it "can parse property accessors" do
    [:foo, :bar, :baz].each do |symbol|
      expect { @receiver.script.get symbol }.to raise_error NoMethodError
      expect { @receiver.script.set symbol, symbol.to_s.upcase }.to raise_error NoMethodError
      
      @receiver.instance_eval {
        define_singleton_method "#{symbol}"  do instance_variable_get "@#{symbol}" end
        define_singleton_method "#{symbol}=" do |value| instance_variable_set "@#{symbol}", value end
        script_property symbol
      } # end instance_eval
      @receiver.script.set symbol, symbol.to_s.upcase
      
      [:property_accessor].each do |root|
        string = "#{symbol.to_s}"
        # Kernel.puts "parsing property accessor #{string} as #{root}..."
        subject.parse(string, :root => root).call(@receiver).should == symbol.to_s.upcase
      end # each root
    end # each
  end # it can parse property accessors
  
  #############################################################################
  # RECEIVER OPERATIONS
  #############################################################################
  
  it "can parse method calls with an explicit receiver" do
    mock_foo = mock_scriptable() {
      script_function :bar do :bizzle end
    } # end instance_eval
    
    @receiver.script.set_global :foo, mock_foo
    
    string = "$foo.bar(:baz)"
    parsed = subject.parse(string, :root => :receiver_operation)
    parsed.call(@receiver).should == :bizzle
  end # it can parse method calls with an explicit receiver
  
  it "can parse chained method calls" do
    mock_baz = mock_scriptable() {
      script_function :wibble do :wobble end
    } # end instance_eval
    
    mock_bar = mock_scriptable() {
      script_function :baz do mock_baz end
    } # end instance_eval
    
    mock_foo = mock_scriptable() {
      script_function :bar do mock_bar end
    } # end instance_eval
    
    @receiver.script.set_global :foo, mock_foo
    
    string = "$foo.bar().baz().wibble()"
    parsed = subject.parse(string, :root => :receiver_operation)
    parsed.call(@env).should == :wobble
  end # it can parse chained method calls
  
  it "can parse chained property accessors" do
    mock_bar = mock_scriptable() {
      define_singleton_method :baz do :bizzle end
      script_property :baz, :only => :read
    } # end instance_eval
    
    mock_foo = mock_scriptable() {
      define_singleton_method :bar do mock_bar end
      script_property :bar, :only => :read
    } # end instance_eval
    
    @receiver.script.set_global :foo, mock_foo
    
    string = "$foo.bar.baz"
    # Kernel.puts "parsing string \"#{string}\" as receiver_operation..."
    parsed = subject.parse(string, :root => :receiver_operation)
    
    parsed.call(@receiver).should == :bizzle
  end # it can parse chained property accessors
=end
end # describe ScriptParser
