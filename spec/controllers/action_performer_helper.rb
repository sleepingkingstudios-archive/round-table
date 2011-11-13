# spec/controllers/action_performer_helper.rb

require 'spec_helper'
require 'controllers/action_performer'

module RoundTable::Mock
  module Controllers; end
end # module RoundTable::Mock

shared_examples "an ActionPerformer" do
  include RoundTable::Controllers
  include RoundTable::Mock::Controllers
  
  def clear_mock
    RoundTable::Mock::Controllers.module_eval do
      remove_const :MockActionPerformer if const_defined? :MockActionPerformer
    end # module_eval
  end # function clear_mock
  
  def define_mock(base_class)
    clear_mock
    
    RoundTable::Mock::Controllers.module_eval do
      klass = Class.new base_class
      const_set :MockActionPerformer, klass
    end # module_eval
  end # function define_mock
  
  before :each do
    define_mock(described_class)
  end # before :each
  
  after :each do
    clear_mock
  end # after :each
  
  subject { MockActionPerformer.new }
  
  it "is an ActionPerformer" do
    described_class.should <= ActionPerformer
  end # it is an ActionPerformer
  
  ##################
  # Defining Actions
  
  it "can define actions on itself" do
    mock_object = double('mock')
    mock_object.should_receive(:bar)
    
    subject.class.instance_eval {
      action :foo do
        mock_object.bar
      end # action :foo
    } # end class.instance_eval
    
    subject.action_foo
  end # it can define actions on itself
  
  it "can define a multi-word action" do
    mock_object = double('mock')
    mock_object.should_receive(:baz)
    
    subject.class.instance_eval {
      action "foo bar" do
        mock_object.baz
      end # action :foo
    } # end class.instance_eval
    
    subject.action_foo_bar
  end # it can define a multi-word action
  
  it "requires a name when defining an action" do
    expect {
      subject.class.instance_eval do
        action
      end # class.instance_eval
    }.to raise_error ArgumentError
  end # it requires a name ...
  
  it "requires a block when defining an action" do
    expect {
      subject.class.instance_eval do
        action :foo
      end # class.instance_eval
    }.to raise_error ArgumentError
  end # it requires a block ...
  
  ###################
  # Executing Actions
  
  it "can execute actions" do
    mock_object = double('mock')
    mock_object.stub(:test) do |*args| end
    mock_object.should_receive(:test).with(:foo, :bar)
    
    subject.class.instance_eval {
      action :do_something do |*args|
        mock_object.test(*args)
      end # action :do_something
    } # end class.instance_eval
    
    subject.execute_action :do_something, :foo, :bar
  end # it can execute actions
  
  #######################
  # Introspecting Actions
  
  it "can list actions defined on it" do
    actions = %w(foo bar baz)
    
    subject.class.instance_eval {
      actions.each do |name|
        action name do; end
      end # each
    } # end class.instance_eval
    
    subject.list_own_actions.should eq actions.sort
  end # it can list actions ...
  
  it "can check if it responds to an action" do    
    subject.has_action?(:do_something).should be false
    
    subject.class.instance_eval {
      action :do_something do; end
    } # end class.instance_eval
    
    subject.has_action?(:do_something).should be true
    subject.has_action?(:do_nothing).should be false
  end # it can check if it responds to an action
end # an ActionPerformer
