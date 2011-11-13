# spec/knights/knight_spec.rb

require 'spec_helper'
require 'knights/knight_helper'
require 'knights/knight'

describe RoundTable::Knights::Knight do
  include RoundTable::Knights
  
  it_behaves_like "a loadable \"knight\" module"
end # describe Knight

module_path = "#{SPEC_PATH}/modules/sir_not_appearing_in_this_film"
require "#{module_path}/init"
require "#{module_path}/lib/modules/knights/sir_not_appearing_in_this_film_knight"

describe SirNotAppearingInThisFilm::Knights::SirNotAppearingInThisFilmKnight do
  it_behaves_like "a loadable \"knight\" module"
end # describe SirNotAppearingInThisFilm
