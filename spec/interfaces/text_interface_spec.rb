# spec/interfaces/text_interface_spec.rb

require 'spec_helper'
require 'controllers/abstract_controller'
require 'interfaces/text_interface'

describe RoundTable::Interfaces::TextInterface do
  let(:controller) {
    controller = mock('controller')
    controller.tap { |obj| obj.stub :is_a? do |mod| mod == RoundTable::Controllers::AbstractController end }
  } # end let :controller
  
  let(:input) {
    input = mock('input')
    input.tap { |obj| obj.stub :respond_to? do |msg| %w(gets).include? msg.to_s end }
    input.tap { |obj| obj.stub :gets }
  } # end let :input
  
  let(:output) {
    output = mock('output')
    output.tap { |obj| obj.stub :respond_to? do |msg| %w(print puts).include? msg.to_s end }
    output.tap { |obj| obj.stub :print }
    output.tap { |obj| obj.stub :puts }
  } # end let :input
  
  let(:string) { "I've got a lovely bunch of coconuts, diddly-dum..."}
  
  describe "initialization" do
    let(:input_sans_gets) {
      input.clone.tap { |obj| obj.stub :respond_to? do |msg| %w().include? msg.to_s end }
    } # end let :input_sans_gets
    
    let(:output_sans_print) {
      output.clone.tap { |obj| obj.stub :respond_to? do |msg| %w(puts).include? msg.to_s end }
    } # end let :output_sans_print
    
    let(:output_sans_puts) {
      output.clone.tap { |obj| obj.stub :respond_to? do |msg| %w(print).include? msg.to_s end }
    } # end let :output_sans_print
    
    it { expect { described_class.new }.to raise_error ArgumentError, /wrong number of arguments/ }
    it { expect { described_class.new nil }.to raise_error ArgumentError, /wrong number of arguments/ }
    it { expect { described_class.new nil, nil }.to raise_error ArgumentError, /wrong number of arguments/ }
    it { expect { described_class.new nil, nil, nil, nil }.to raise_error ArgumentError, /wrong number of arguments/ }
    
    it { expect { described_class.new nil, input, output }.to raise_error ArgumentError, /controller not to be nil/ }
    it { expect { described_class.new :sym, input, output }.to raise_error ArgumentError, /expected controller to be.+AbstractController/ }
    
    it { expect { described_class.new controller, nil, output }.to raise_error ArgumentError, /input not to be nil/ }
    it { expect { described_class.new controller, input_sans_gets, output }.to raise_error ArgumentError, /input to respond to :gets/ }
    
    it { expect { described_class.new controller, input, nil }.to raise_error ArgumentError, /output not to be nil/ }
    it { expect { described_class.new controller, input, output_sans_print }.to raise_error ArgumentError, /output to respond to :print/ }
    it { expect { described_class.new controller, input, output_sans_puts }.to raise_error ArgumentError, /output to respond to :puts/ }
  end # describe initialization
  
  context "(initialized)" do
    before :each do
      @interface = described_class.new controller, input, output
    end # before :each
    subject { @interface }
    
    describe "root controller property" do
      let(:alt_controller) { controller.clone }
      
      it { subject.root_controller.should be controller }
      it { expect { subject.root_controller = nil }.to raise_error ArgumentError, /controller not to be nil/i }
      it { expect { subject.root_controller = :sym }.to raise_error ArgumentError, /controller to be.+AbstractController/i }
      it { expect { subject.root_controller = alt_controller }.not_to raise_error }
      
      context "(set)" do
        before :each do
          subject.root_controller = alt_controller
        end # before :each
        
        it { subject.root_controller.should be alt_controller }
      end # context (set)
    end # describe root controller property
    
    describe "gets method" do
      before :each do
        input.stub :gets do string end
      end # before :each
      
      it { subject.gets.should == string }
    end # describe gets method
    
    describe "print method" do
      it "should send message to output" do
        output.should_receive(:print).with(string)
        subject.print string
      end # it should send ... to output
    end # describe print method
    
    describe "puts method" do
      it "should send message to output" do
        output.should_receive(:puts).with(string)
        subject.puts string
      end # it should send ... to output
    end # describe puts method
    
    describe "put sequence method" do
      let(:sequence) {
        [ "Cur in gremio haeremus?",
          "Cur poenam cordi parvo damus?",
          "Stella nobis non concessit"
        ] # end anonymous Array
      } # end let :sequence
      
      describe "with one string" do
        it "should send one message to output" do
          output.should_receive(:puts).with(sequence[0])
          output.should_receive(:puts).with(/press enter to continue, or type \"skip\" to skip this text/i)
          subject.put_ary sequence[0]
        end # it should send one ... output
      end # describe with one string
      
      describe "with an array containing one string" do
        it "should send one message to output" do
          output.should_receive(:puts).with(sequence[0])
          output.should_receive(:puts).with(/press enter to continue, or type \"skip\" to skip this text/i)
          subject.put_ary sequence[0..0]
        end # it should send one ... output
      end # describe with an array ... one string
      
      describe "with an array containing multiple strings" do
        it "should send each message to output" do
          sequence.each do |str|
            output.should_receive(:puts).with(str)
          end # each
          output.should_receive(:puts).with(/press enter to continue, or type \"skip\" to skip this text/i).once()
          subject.put_ary sequence
        end # it should send each ...
      end # describe with an array ... multiple strings
      
      describe "should skip when given an input of skip" do
        it "should send one and only one message to output" do
          output.should_receive(:puts).with(sequence[0])
          output.should_not_receive(:puts).with(sequence[1])
          output.should_receive(:puts).with(/press enter to continue, or type \"skip\" to skip this text/i).once()
          input.stub :gets do "skip\n" end
          subject.put_ary sequence
        end # it should send one and only one message to output
      end # describe it should skip ...
    end # describe put sequence method
  end # context (initialized)
end # describe RoundTable::Interfaces::TextInterface
