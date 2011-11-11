# lib/contexts/shrubbery_context.rb

require 'controllers/contexts/base_context'
require 'modules/contexts/contexts'

module SirNotAppearingInThisFilm::Contexts
  class ShrubberyContext < RoundTable::Controllers::Contexts::BaseContext
    action :ni do |*args|
      self.puts "You must cut down the mightiest tree in the forest...with" +
        "...A HERRING!\a\a\a"
    end # action :ni
  end # class ShrubberyContext
end # module SirNotAppearingInThisFilm::Contexts
