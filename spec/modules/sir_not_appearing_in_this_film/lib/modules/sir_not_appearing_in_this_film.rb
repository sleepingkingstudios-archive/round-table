# spec/modules/sir_not_appearing_in_this_film/lib/sir_not_appearing_in_this_film.rb

require 'vendor/modules'
require 'modules/knights/sir_not_appearing_in_this_film'

module RoundTable::Vendor::Modules
  module SirNotAppearingInThisFilm
    def self.knight
      Knights::SirNotAppearingInThisFilm.new
    end # module method Knight
  end # module SirNotAppearingInThisFilm
end # module RoundTable::Modules

include RoundTable::Vendor::Modules::SirNotAppearingInThisFilm
