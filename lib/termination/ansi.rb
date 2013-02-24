require 'term/ansicolor'

class Termination
  module ANSI
    extend Term::ANSIColor
    NON_ANSI = /\e\[.*?m/

    def self.cursor(row, col)
      "\e[#{row};#{col}H"
    end

    def self.clear_screen
      "\e[2J\e[H"
    end
  end
end