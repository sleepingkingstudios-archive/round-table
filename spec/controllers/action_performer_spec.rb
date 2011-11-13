# spec/controllers/action_performer_spec.rb

require 'spec_helper'
require 'controllers/action_performer_helper'
require 'controllers/action_performer'

describe RoundTable::Controllers::ActionPerformer do
  it_behaves_like "an ActionPerformer"
  
  it "raises an error for unrecognized actions" do
    expect { subject.execute_action :unknown_action }.to raise_error NoMethodError
  end # it raises an error ...
end # describe ActionPerformer
