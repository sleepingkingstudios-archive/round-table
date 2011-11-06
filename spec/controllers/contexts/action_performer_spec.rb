# spec/controllers/contexts/action_performer_spec.rb

require 'spec_helper'
require 'controllers/contexts/action_performer'

describe RoundTable::Controllers::Contexts::ActionPerformer do
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
  
  it "can list actions defined on it" do
    actions = %w(foo bar baz)
    
    subject.class.instance_eval {
      actions.each do |name|
        action name do; puts "#{name}"; end
      end # each
    } # end class.instance_eval
    
    subject.list_own_actions.should eq actions.sort
  end # it can list actions ...
  
  it "can execute actions" do
    mock_object = double('mock')
    mock_object.stub(:test) do |*args| end
    mock_object.should_receive(:test)# .with(:foo, :bar)
    
    subject.class.instance_eval {
      action :do_something do |*args|
        mock_object.test(*args)
      end # action :do_something
    } # end class.instance_eval
    
    subject.execute_action :do_something, :foo, :bar
  end # it can execute actions
  
  it "raises an error for unrecognized actions" do
    expect { subject.execute_action :unknown_action }.to raise_error NoMethodError
  end # it raises an error ...
end # describe ActionPerformer
