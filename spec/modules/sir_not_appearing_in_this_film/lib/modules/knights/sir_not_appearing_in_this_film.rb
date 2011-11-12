# spec/modules/sir_not_appearing_in_this_film/lib/knights/sir_not_appearing_in_this_film.rb

require 'knights/knight'
require 'modules/knights/knights'
require 'modules/controllers/shrubbery_controller'

module SirNotAppearingInThisFilm::Knights
  class SirNotAppearingInThisFilm < RoundTable::Knights::Knight
    def initialize(params = {})
      # constructor
    end # method initialize
    
    def controller
      SirNotAppearingInThisFilm::Controllers::ShrubberyController.new
    end # method build_context
    
    def message(*args)
      case args.map{|arg| arg.to_s }.join(" ").strip
      when "initialize"
        return "I am Arthur, King of the Britons."
      else
        super
      end # case
    end # method message
  end # class SirNotAppearingInThisFilm
end # module SirNotAppearingInThisFilm::Knights
