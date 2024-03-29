# spec/controllers/action_performer_helper.rb

require 'spec_helper'
require 'controllers/action_performer'

shared_examples "an ActionPerformer" do
  it "is an ActionPerformer" do
    described_class.should <= RoundTable::Controllers::ActionPerformer
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
  
  it "can alias actions" do
    mock_object = double('mock')
    mock_object.should_receive(:baz)
    
    subject.class.instance_eval {
      action :foo do
        mock_object.baz
      end # action :foo
      
      alias_action :bar, :foo
    } # end class.instance_eval
    
    subject.execute_action :bar
  end # it can alias actions
  
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
  
  describe "defining singleton actions" do
    it "expects a name and a block" do
      expect {
        subject.define_singleton_action :wibble do
          :wobble
        end # action
      }.not_to raise_error
    end # end it
    
    it "requires a block" do
      expect {
        subject.define_singleton_action :no_op
      }.to raise_error ArgumentError
    end # it requires a block
    
    context "(defined)" do
      before :each do
        subject.define_singleton_action :wibble do; end
      end # before :each
      
      describe "executing singleton actions" do
        it { expect { subject.execute_action :wibble }.not_to raise_error }
      end # describe executing singleton actions
      
      describe "listing singleton actions" do
        it { subject.list_own_actions.should include "wibble" }
      end # describe listing singleton actions
      
      describe "introspecting singleton actions" do
        it { subject.has_action?(:wibble).should be true }
      end # introspecting singleton actions
    end # context (defined)
  end # describe defining singleton actions

end # an ActionPerformer
