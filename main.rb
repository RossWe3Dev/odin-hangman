require "colorize"
require_relative "lib/game"

def play_game
  puts "Let's play Hangman".colorize(:green)
  hangman = Game.new
  hangman.play
  play_again
end

def play_again
  puts "Press 'y' to play again :) [y/quit]".colorize(:green)
  if gets.chomp.downcase == "y"
    play_game
  else
    puts "Thanks for playing!".colorize(:green)
  end
end

play_game
