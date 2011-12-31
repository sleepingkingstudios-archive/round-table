# spec/controllers/delegate_controller_spec.rb

require 'spec_helper'
require 'controllers/action_delegate'
require 'controllers/delegate_controller'
require 'events/event_dispatcher'

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
  
  context "(initialized)" do
    before :each do
      @controller = described_class.new
      @controller.define_singleton_action :bar do
        self.puts "In England, these are called pubs."
      end # action :bar
    end # before :each
    subject { @controller }
    
    let(:foo_performer) { FooPerformer.new }
    let(:bar_performer) { BarPerformer.new }
    let(:baz_performer) { BazPerformer.new }
    
    describe "delegates" do    
      describe "adding delegates" do
        let(:key) {  }
      
        it { expect { subject.add_delegate }.to raise_error ArgumentError, /wrong number/i }
        it { expect { subject.add_delegate key }.to raise_error ArgumentError, /wrong number/i }
        it { expect { subject.add_delegate key, nil }.to raise_error ArgumentError, /not to be nil/i }
        it { expect { subject.add_delegate key, :foo }.to raise_error ArgumentError, /ActionDelegate/i }
        it { expect { subject.add_delegate key, foo_performer }.not_to raise_error }
      end # describe adding delegates
      
      context "(added)" do
        let(:keys_and_delegates) {
          { :foo => foo_performer,
            :bar => bar_performer,
            nil  => baz_performer
          } # end Hash
        } # end let
        
        before :each do
          keys_and_delegates.each do |key, delegate|
            subject.add_delegate key, delegate
          end # each
        end # before :each
        
        it { subject.should have_key :foo }
        it { subject.should have_key :bar }
        it { subject.should have_key nil }
        
        it { subject.should have_delegate foo_performer }
        it { subject.should have_delegate bar_performer }
        it { subject.should have_delegate baz_performer }
        
        describe "removing delegates" do
          it { expect { subject.remove_delegate }.to raise_error ArgumentError, /wrong number/i }
          it { expect { subject.remove_delegate nil }.to raise_error ArgumentError, /not to be nil/i }
          it { expect { subject.remove_delegate :foo }.to raise_error ArgumentError, /ActionDelegate/i }
          it { expect { subject.remove_delegate foo_performer }.not_to raise_error }
          
          it { expect { subject.remove_delegate_by_key }.to raise_error ArgumentError, /wrong number/i }
          it { expect { subject.remove_delegate_by_key :wibble }.to raise_error ArgumentError, /no delegate with key/i }
          it { expect { subject.remove_delegate_by_key :bar }.not_to raise_error }
          it { expect { subject.remove_delegate_by_key nil }.not_to raise_error }
        end # describe removing delegates
        
        context "(and removed)" do
          before :each do
            subject.remove_delegate foo_performer
            subject.remove_delegate_by_key :bar
            subject.remove_delegate_by_key nil
          end # before :each
          
          it { subject.should_not have_key :foo }
          it { subject.should_not have_key :bar }
          it { subject.should_not have_key nil }
          
          it { subject.should_not have_delegate foo_performer }
          it { subject.should_not have_delegate bar_performer }
          it { subject.should_not have_delegate bar_performer }
        end # context (and removed)

        describe "introspecting actions" do
          it { subject.delegates_for(:foo).should include foo_performer }
          it { subject.delegates_for(:bar).should include bar_performer }
          it { subject.delegates_for(:baz).should include baz_performer }
          
          it { subject.list_all_actions.should include *%w(foo bar baz) }
        end # describe introspecting actions
        
        describe "executing delegated actions" do
          def self.match_event(action, *args, &block)
            it { "with action = #{action}, args = #{args}"
              subject.add_listener :*, Proc.new { |event|
                block.call(event)
              } # end Proc.new
              subject.execute_action action, *args
            } # end it with action ... args ...
          end # function match_event
          
          match_event :foo, "foo" do |event|
            event[:text].should =~ /foo/i
          end # match_event
          
          match_event :bar, "bar" do |event|
            event[:text].should =~ /bar/i
          end # match_event
          
          match_event :baz do |event|
            event[:text].should =~ /baz/i
          end # match_event
        end # describe executing delegated actions
      end # context (added)
    end # describe delegates
  end # context initialized
end # describe DelegateController
