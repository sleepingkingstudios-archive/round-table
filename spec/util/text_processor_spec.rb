# spec/util/text_processor_spec.rb

require 'spec_helper'
require 'util/text_processor'

module RoundTable::Mock::Util
  class MockTextProcessor
    include RoundTable::Util::TextProcessor
  end # class MockTextProcessor
end # module RoundTable::Mock::Util

describe RoundTable::Util::TextProcessor do
  include RoundTable::Util
  include RoundTable::Mock::Util
  
  subject { MockTextProcessor.new }
  
  ##################
  # Tokenize Strings
  
  it "can convert a string to an array of tokens" do
    input = "verb object preposition object"
    
    subject.tokenize(input).should eq input.downcase.split.map {|str| str.chomp}
  end # it can convert a string to an array of tokens
  
  it "can convert a token to a boolean" do
    subject.token_to_boolean("y").should be true
    subject.token_to_boolean("yes").should be true
    subject.token_to_boolean("true").should be true
    subject.token_to_boolean("affirmative").should be true
    subject.token_to_boolean("no").should be false
    subject.token_to_boolean("foo").should be false
    subject.token_to_boolean("xyzzy").should be false
  end # it can convert a token to a boolean
  
  it "can break strings into lines with a max character width" do
    length = 80
    text = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do" +
      " eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim" +
      " ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut" +
      " aliquip ex ea commodo consequat. Duis aute irure dolor in" +
      " reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla" +
      " pariatur. Excepteur sint occaecat cupidatat non proident, sunt in" +
      " culpa qui officia deserunt mollit anim id est laborum."
    
    broken_text = subject.break_text(text, length)
    broken_text.should be_a String
    broken_text.gsub(/\-\n/, "").gsub(/\s+/, " ").should eq(text.strip)
    broken_text.split("\n").each do |line|
      line.length.should be <= length
    end # each
  end # it can break strings ...
    
  it "can break words into lines using hyphens" do
    length = 10
    text = "The word \"Honorificabilitudinitatibus\" means the state of" +
      " being able to achieve honours."
    broken_text = subject.break_text(text, length)
    broken_text.gsub(/\-\n/, "").gsub(/\s+/, " ").should match(text.strip)
    broken_text.split("\n").each do |line|
      line.length.should be <= length
    end # each
  end # it can break words ...
  
  #################
  # Text Formatting
  
  it "preserves newlines in broken strings" do
    text = "This text contains newlines.\nNewlines must be preserved.\n\n" +
      "Each newline is indicated by a \\n escaped character, which is a" +
      " standard character used to indicate a line feed."
      
    broken_text = subject.break_text(text)
    text.should =~ /^This text contains/
    text.should =~ /newlines.\nNewlines must/
    text.should =~ /preserved.\n\nEach newline/
    text.should =~ /by a \\n escaped/
    
    # puts "#{broken_text.gsub(/\n/, "\\n")}"
  end # it preserves newlines ...
  
  it "converts unknown case to snake_case" do
    snake_string = "this_is_snake_case"
    camel_string = "ThisIsSnakeCase"
    space_string = "This is snake-case"
    
    TextProcessor.to_snake_case(snake_string).should eq snake_string
    TextProcessor.to_snake_case(camel_string).should eq snake_string
    TextProcessor.to_snake_case(space_string).should eq snake_string
  end # it converts ... to snake_case
  
  it "converts unknown case to CamelCase" do
    snake_string = "this_is_camel_case"
    camel_string = "ThisIsCamelCase"
    space_string = "This is camel-case"
    
    TextProcessor.to_camel_case(snake_string).should eq camel_string
    TextProcessor.to_camel_case(camel_string).should eq camel_string
    TextProcessor.to_camel_case(space_string).should eq camel_string
  end # it converts unknown case to CamelCase
end # describe TextProcessor
