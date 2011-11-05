# app/controllers/contexts/abstract_context.rb

require 'spec_helper'
require 'controllers/contexts/abstract_context'

module RoundTable::Mock
  module Controllers
    module Contexts
      class MockContextContainer
        
      end # class MockContextContainer
    end # module Contexts
  end # module Controllers
end # module RoundTable::Mock

describe RoundTable::Controllers::Contexts::AbstractContext do
  include RoundTable::Controllers::Contexts
  
  it "should parse text input" do
    string = "verb verb_object preposition prep_object"
    subject.parse string
  end # it should parse text input
end # describe RoundTable::Controllers::Contexts::AbstractContext
