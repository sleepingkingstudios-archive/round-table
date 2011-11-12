# lib/controllers/shrubbery_controller.rb

require 'controllers/base_controller'
require 'modules/controllers/controllers'

module SirNotAppearingInThisFilm::Controllers
  class ShrubberyController < RoundTable::Controllers::BaseController
    action :ni do |*args|
      self.puts "You must cut down the mightiest tree in the forest...with" +
        "...A HERRING!\a\a\a"
    end # action :ni
  end # class ShrubberyController
end # module SirNotAppearingInThisFilm::Controllers
