# spec/controllers/delegate_controller_spec.rb

require 'spec_helper'
require 'controllers/action_delegate'
require 'controllers/delegate_controller'

module RoundTable::Mock
  module Controllers; end
end # module RoundTable::Mock

describe RoundTable::Controllers::DelegateController do
  include RoundTable::Controllers
  include RoundTable::Events
  include RoundTable::Mock::Controllers
  
  before :each do
    RoundTable::Mock::Controllers.module_eval do
      [:foo, :bar, :baz].each do |sym|
        str = sym.to_s.capitalize
        remove_const "#{str}Performer" if const_defined? "#{str}Performer"
        
        klass = Class.new RoundTable::Controllers::ActionDelegate
        klass.class_eval {
          action sym do |*args|
            self.puts "#{str} is a metasyntactic variable."
          end # action :foo
        } # end class_eval
        
        const_set "#{str}Performer", klass
      end # each
    end # module_eval
  end # before :all
  
  after :each do
    RoundTable::Mock::Controllers.module_eval do
      [:FooPerformer, :BarPerformer, :BazPerformer].each do |sym|
        remove_const sym if const_defined? sym
      end # each
    end # module_eval
  end # after :each
  
  ####################
  # Managing Delegates
  
  it "can add delegates" do
    delegate = FooPerformer.new
    subject.add_delegate delegate
    
    event = Event.new :foo_event
    
    mock = double('callable')
    mock.stub(:call)
    mock.should_receive(:call).with(event)
    
    subject.add_listener :foo_event, Proc.new { |event|
      mock.call event
    } # listener :foo_event
    
    delegate.dispatch_event event
  end # it can add delegates
  
  it "raises an error if delegate is not an ActionDelegate" do
    expect { subject.add_delegate("delegate") }.to raise_error ArgumentError
  end # it raises an error ...
  
  it "can remove delegates" do
    delegate = FooPerformer.new
    subject.add_delegate delegate
    subject.remove_delegate delegate
    
    event = Event.new :foo_event
    
    mock = double('callable')
    mock.stub(:call)
    mock.should_not_receive(:call)
    
    subject.add_listener :foo_event, Proc.new { |event|
      mock.call event
    } # listener :foo_event
    
    delegate.dispatch_event event
  end # it can remove delegates
  
  context "once initialized" do
    before :each do
      @subject = described_class.new
      
      @foo = FooPerformer.new
      @bar = BarPerformer.new
      @baz = BazPerformer.new
      
      @subject.add_delegate @foo
      @subject.add_delegate @bar
      @subject.add_delegate @baz
    end # before :each
    
    #######################
    # Introspecting Actions
    
    it "lists its own actions, plus those of its delegates" do
      actions = @subject.list_own_actions
      actions += @foo.list_own_actions
      actions += @bar.list_own_actions
      actions += @baz.list_own_actions
      
      actions = actions.uniq.sort
      @subject.list_all_actions.should eq actions
    end # it lists its own actions, plus those of its delegates
    
    it "lists delegates responding to an action" do
      @subject.class.instance_eval do
        action :foo do |*args|; end
      end # class.instance_eval
      
      delegates = @subject.delegates_for(:foo)
      delegates.should include(@subject)
      delegates.should include(@foo)
    end # it lists delegates responding to an action
    
    ###################
    # Executing Actions
    
    it "passes actions to its delegates by key" do
      @bar.class.instance_eval do
        action :foo do |*args|
          self.execute_action :bar, *args
        end # action :foo
      end # class_eval
      
      @subject.delegates_for(:foo).should include(@foo)
      @subject.delegates_for(:foo).should include(@bar)
      
      mock = double('callable')
      mock.stub(:call)
      
      @subject.add_listener :text_output, Proc.new { |event|
        mock.call event[:text]
      } # listener :text_output
      
      %w(Foo Bar).each do |str|
        mock.should_receive(:call).with("#{str} is a metasyntactic variable.")
      end # each
      
      @subject.execute_action :foo, "FooPerformer"
      @subject.execute_action :foo, "BarPerformer"
    end # it passes actions to its delegates by key do
  end # context initialized
end # describe DelegateController
