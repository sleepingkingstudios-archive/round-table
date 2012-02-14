# spec/scripts/scriptable_spec.rb

require 'spec_helper'
require 'scripts/scriptable'
require 'scripts/script_helper'

module RoundTable::Mock
  module Scripts; end
end # module RoundTable::Mock

describe RoundTable::Scripts::Scriptable do
  pending "Not sure whether this will be implemented or not..."
=begin
  subject {
    klass = Class.new
    klass.instance_eval do
      include RoundTable::Scripts::Scriptable
    end # instance_eval
    
    klass.new
  } # end subject
  
  it "should be scriptable" do
    subject.should be_a Scriptable
  end # it should be scriptable
  
  it "should initialize a helper" do
    expect { subject.initialize_scripting }.to raise_error
    
    subject.instance_eval {
      initialize_scripting
    } # end instance_eval
    subject.instance_variable_get(:@script).should be_a ScriptHelper
    subject.send(:script).should be_a ScriptHelper
    subject.instance_variable_get(:@script).should == subject.send(:script)
  end # it should initialize a helper
  
  it "should initialize a helper with alternate name" do
    subject.instance_eval {
      initialize_scripting :as => :wibble
    } # end instance_eval
    subject.instance_variable_get(:@wibble).should be_a ScriptHelper
    subject.send(:wibble).should be_a ScriptHelper
    subject.instance_variable_get(:@wibble).should == subject.send(:wibble)
  end # it should initialize a helper
  
  context "when it has been initialized," do
    before :each do
      subject.instance_eval {
        initialize_scripting
      } # end subject.instance_eval
      
      subject.script.class.class_eval {
        class_variable_set :@@global_functions, Hash.new
        class_variable_set :@@global_variables, Hash.new
      } # end class_eval
    end # before :each
    
    it "can register properties as scriptable" do
      subject.instance_eval {
        self.instance_variable_set :@foo, "foo"
        self.define_singleton_method :foo, Proc.new { @foo }
        self.define_singleton_method :foo=, Proc.new { |value| @foo = value }
        script_property :foo
      } # end instance_eval
      
      subject.script.get(:foo).should == "foo"
      subject.script.set(:foo, "FOO")
      subject.instance_variable_get(:@foo).should == "FOO"
    end # it can register properties as scriptable
    
    it "can register properties as read-only" do
      subject.instance_eval {
        self.instance_variable_set :@bar, "bar"
        self.define_singleton_method :bar, Proc.new { @bar }
        script_property :bar, :only => :read
      } # end instance_eval
      
      subject.script.get(:bar).should == "bar"
      expect { subject.script.set(:bar, "BAR") }.to raise_error NoMethodError
    end # it can register properties as read-only
    
    it "can register properties as write-only" do
      subject.instance_eval {
        self.instance_variable_set :@baz, "baz"
        self.define_singleton_method :baz=, Proc.new { |value| @baz = value }
        script_property :baz, :only => :write
      } # end instance_eval
      
      expect { subject.script.get(:baz) }.to raise_error NoMethodError
      subject.script.set(:baz, "BAZ")
      subject.instance_variable_get(:@baz).should == "BAZ"
    end # it can register properties as write-only
    
    it "can register functions and methods as callable" do
      mock = double('callable')
      mock.stub(:call)
      
      subject.instance_eval {
        self.define_singleton_method :test, Proc.new { |*vars|
          mock.call(*vars)
        } # end method call
        
        script_function :test, self.method(:test)
        script_function :test_again, Proc.new {
          mock.call(:wibble, :wobble)
        } # end function call_again
      } # end subject.instance_eval
      
      mock.should_receive(:call).with(:foo, :bar)
      subject.script.call :test, :foo, :bar
      
      mock.should_receive(:call).with(:wibble, :wobble)
      subject.script.call :test_again
    end # it can register functions and methods ...
    
    ################################
    # Global Variables and Functions
    
    it "can set and get global variables" do
      subject.script.get_global(:foo).should be nil
      subject.script.set_global(:foo, "Foo").should == "Foo"
      subject.script.get_global(:foo).should == "Foo"
      
      klass = Class.new
      klass.instance_eval do
        include RoundTable::Scripts::Scriptable
      end # instance_eval

      new_subject = klass.new
      new_subject.instance_eval {
        initialize_scripting
      } # end instance_eval
      
      new_subject.script.get_global(:foo).should == "Foo"
    end # it can set and get global variables
    
    it "can define and call global functions" do
      expect { subject.script.define_global :foo, nil }.to raise_error ArgumentError
      
      mock = double('callable')
      mock.stub(:call)
      
      subject.script.define_global :foo, Proc.new { |*args|
        mock.call(*args)
      } # end global :foo
      
      mock.should_receive(:call).with(:bar, "baz")
      subject.script.call_global(:foo, :bar, "baz")
    end # it can define and call global functions
  end # context when it has been initialized
=end
end # describe Scriptable
