# lib/util/text_processor.rb

require 'util/util'

module RoundTable::Util
  module TextProcessor
    def break_text(text, length = 80)
      leading  = (text.match(/\A\s+/) || [""])[0]
      trailing = (text.match(/\s+\Z/) || [""])[0]
      
      substrings = text.strip.split(/\n/)
      text = substrings.map { |string|
        words = string.split(/\s/)
        lines = []
        line = ""

        words.each_index do |index|
          word = words[index]
          if word.length + line.length < length then
            line += " " if index > 0
            line += "#{word}"
          else
            lines << line
            while word.length > length
              line = "#{word.slice!(0...(length-1))}-"
              lines << line
            end # while
            line = "#{word}"
          end # if-else
        end # each
        lines << line

        lines.join("\n").gsub(/^\ +|\ +$/, '')
      }.join("\n")
      
      "#{leading}#{text}#{trailing}"
    end # method break_text
    
    ##################
    # Tokenize Strings
    
    def tokenize(string)
      string.downcase.split.map { |str| str.strip }
    end # method tokenize
    
    def token_to_boolean(string)
      %w(y yes true affirmative).include? string.downcase.strip
    end # method token_to_boolean
  end # module TextProcessor
end # module RoundTable::Util

