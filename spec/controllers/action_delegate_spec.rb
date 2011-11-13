# spec/controllers/action_delegate_spec.rb

require 'spec_helper'
require 'controllers/action_delegate_helper'
require 'controllers/action_delegate'

describe RoundTable::Controllers::ActionDelegate do
  include RoundTable::Controllers
  
  it_behaves_like "an ActionDelegate"
end # describe ActionDelegate
