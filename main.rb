require "colorize"
require_relative "lib/game"

def play_game
  puts "Let's play Hangman".colorize(:yellow)
  hangman = Game.new
  hangman.play
  play_again
end

def play_again
  puts "\nPress 'y' to play again :) [y/quit]".colorize(:cyan)
  if gets.chomp.downcase == "y"
    play_game
  else
    puts "Thanks for playing!".colorize(:magenta)
  end
end

play_game
