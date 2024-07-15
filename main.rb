require "colorize"
require_relative "lib/game"

def play_game
  puts "Let's play Hangman!".colorize(:yellow)
  hangman = check_saved_file
  hangman.play
  play_again
end

def play_again
  puts "\nPress 'y' to continue playing :) [y / quit]".colorize(:cyan)
  if gets.chomp.downcase == "y"
    play_game
  else
    puts "Thanks for playing!".colorize(:magenta)
  end
end

def check_saved_file
  if File.empty?("saved_game.json")
    Game.new
  else
    puts "There is a saved game, would you like to continue it? [yes / no]".colorize(:cyan)
    restore_saved_file?
  end
end

def restore_saved_file?
  loop do
    answer = gets.chomp.downcase.strip
    if answer == "yes"
      return Game.new
    elsif answer == "no"
      File.open("saved_game.json", "w") { |file| file.truncate(0) }
      return Game.new
    else
      puts "Invalid input. Please answer 'yes' or 'no'!".colorize(:red)
    end
  end
end

play_game
