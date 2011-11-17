# spec/scripts/script_parser_spec.rb

require 'spec_helper'
require 'scripts/scriptable'
require 'scripts/script_parser'

describe RoundTable::Scripts::ScriptParser do
  #####################
  # Scalars and Strings
  
  before :each do
    @env = mock('callable')
    @env.stub(:send)
  end # before :each
  
  it "can parse integer scalars" do
    [0, 1, -1, 10, 1337].each do |integer|
      # Kernel.puts "parsing integer \"#{integer}\"..."
      subject.parse("#{integer}", :root => :integer).call().should == integer
    end # each
  end # it can parse integer scalars do
  
  it "can parse symbol scalars" do
    [:foo, :bar, :_baz, :__bizzle__, :wibble_wobble].each do |symbol|
      # Kernel.puts "parsing symbol \":#{symbol}\"..."
      subject.parse(":#{symbol}", :root => :symbol).call().should == symbol
    end # each
  end # it can parse symbol scalars
  
  it "can parse plain strings" do
    [
      "Hello, world!",
      "This is a test string\n",
      "\t- I hope\nyou\nlike it!\r\n",
      "Now is the the winter of our discontent, turned glorious summer by" +
        " this son of York",
    ].each do |string|
      # Kernel.puts "parsing string \"#{string}\"..."
      subject.parse("\"#{string}\"", :root => :string).call().should == string
    end # each
  end # it can parse plain strings
  
  it "can parse scalars as scalars" do
    subject.parse("13", :root => :scalar).call().should == 13
    subject.parse(":foo", :root => :scalar).call().should == :foo
    subject.parse("\"Hello, world!\"", :root => :scalar).call().should == "Hello, world!"
  end # it can parse scalars as scalars
  
  it "can parse scalars as expressions" do
    subject.parse("13", :root => :expression).call().should == 13
    subject.parse(":foo", :root => :expression).call().should == :foo
    subject.parse("\"Hello, world!\"", :root => :expression).call().should == "Hello, world!"
  end # it can parse scalars as expressions
  
  ###########
  # Functions
  
  it "can parse function calls" do
    string = "foo(0, :bar, \"baz\")"
    parsed = subject.parse(string, :root => :function_call)
    # Kernel.puts parsed.inspect
    
    @env.should_receive(:send).with(:foo, 0, :bar, "baz")
    parsed.call(@env)
  end # it can parse function calls
  
  it "can parse nested function calls" do
    received_args = nil
    @env.stub(:send) { |*args|
      case args.first
      when :foo
        :wibble
      when :bar
        received_args = args[1..-1]
      end # case arg
    } # end stub
    
    string = "bar( foo() )"
    parsed = subject.parse(string, :root => :function_call)
    parsed.call(@env)
    
    received_args.should include(:wibble)
  end # "it can parse nested function calls" do
  
  it "can parse function calls as expressions" do
    @env.should_receive(:send).with(:wibble)
    subject.parse("wibble()").call(@env)
    
    string = "foo(0, :bar, \"baz\")"
    parsed = subject.parse(string, :root => :expression)
    
    @env.should_receive(:send).with(:foo, 0, :bar, "baz")
    parsed.call(@env)
  end # it can parse function calls as expressions
  
  ##########################
  # Properties and Variables
  
  it "can parse property accessors" do
    @env.stub(:get) { |*args|
      case args.shift
      when :foo
        "fo'shizzle!"
      when :bar
        "Kampai!"
      else
        raise ArgumentError.new
      end # case args.shift
    } # end stub get
    
    subject.parse("foo", :root => :read_property).call(@env).should == "fo'shizzle!"
    subject.parse("bar", :root => :read_property).call(@env).should == "Kampai!"
  end # it can parse property accessors
  
  it "can parse property mutators" do
    foo, bar, baz = nil
    @env.stub(:send) { |*args|
      case args.shift
      when :wibble
        :wobble
      else
        raise ArgumentError.new
      end # args.shift
    } # end stub send
    @env.stub(:set) { |*args|
      case args.shift
      when :foo
        foo = args
      when :bar
        bar = args
      when :baz
        baz = args
      else
        raise ArgumentError.new
      end # case args.shift
    } # end stub set
    
    subject.parse("foo = :foo", :root => :write_property).call(@env).should == [:foo]
    subject.parse("bar = \"bar\"", :root => :write_property).call(@env).should == ["bar"]
    subject.parse("baz = wibble()", :root => :write_property).call(@env).should == [:wobble]
  end # it can parse property mutators
  
  it "can parse accessors and mutators as expressions" do
    @env.stub(:get)
    @env.stub(:set)
    
    @env.should_receive(:get).with(:foo)
    @env.should_receive(:set).with(:bar, "baz")
    
    subject.parse("foo", :root => :expression).call(@env)
    subject.parse("bar = \"baz\"", :root => :expression).call(@env)
  end # it can parse accessors and mutators as expressions
  
  it "can parse global variable accessors" do
    @env.stub(:get_global) { |*args|
      case args.shift
      when :foo
        "FOO"
      else
        raise ArgumentError.new
      end # case args.shift
    } # end stub get_global
    
    @env.should_receive(:get_global).with(:foo)
    
    subject.parse("$foo", :root => :read_global_variable).call(@env).should == "FOO"
  end # it can parse global variable accessors
  
  it "can parse global variable mutators" do
    foo = nil
    @env.stub(:set_global) { |*args|
      case args.shift
      when :foo
        foo = args.first
      else
        raise ArgumentError.new
      end # case args.shift
    } # end stub set_global
    
    @env.should_receive(:set_global).with(:foo, "FOO")
    
    subject.parse("$foo = \"FOO\"", :root => :write_global_variable).call(@env).should == "FOO"
  end # it can parse global variable mutators
  
  it "can parse global accessors and mutators as expressions" do
    @env.stub(:get_global)
    @env.stub(:set_global)
    
    @env.should_receive(:get_global).with(:foo)
    @env.should_receive(:set_global).with(:bar, "baz")
    
    subject.parse("$foo", :root => :expression).call(@env)
    subject.parse("$bar = \"baz\"", :root => :expression).call(@env)
  end # can parse global accessors and mutators as expressions
  
  #############
  # Expressions
  
end # describe ScriptParser
