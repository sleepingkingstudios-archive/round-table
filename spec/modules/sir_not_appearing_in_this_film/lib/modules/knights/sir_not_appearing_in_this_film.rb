# spec/modules/sir_not_appearing_in_this_film/lib/knights/sir_not_appearing_in_this_film.rb

require 'knights/knight'
require 'modules/knights/knights'
require 'modules/contexts/shrubbery_context'

module SirNotAppearingInThisFilm::Knights
  class SirNotAppearingInThisFilm < RoundTable::Knights::Knight
    def initialize(params = {})
      # constructor
    end # method initialize
    
    def build_context
      SirNotAppearingInThisFilm::Contexts::ShrubberyContext.new
    end # method build_context
  end # class SirNotAppearingInThisFilm
end # module SirNotAppearingInThisFilm::Knights
