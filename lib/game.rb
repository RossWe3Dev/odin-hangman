require "colorize"
require "json"

class Game
  attr_reader :secret_word, :guessed_letters, :dashes, :lives_left, :current_guess, :saved_file

  def initialize
    if File.exist?("saved_game.txt") && !File.empty?("saved_game.txt")
      load_game
    else
      @secret_word = pick_random_word
      @guessed_letters = []
      @dashes = []
      @lives_left = 8
      @current_guess = nil
      @saved_file = false
    end
  end

  def load_game
    data = JSON.parse(File.read("saved_game.txt"))
    @secret_word = data["secret_word"]
    @guessed_letters = data["guessed_letters"]
    @dashes = data["dashes"]
    @lives_left = data["lives_left"]
    @current_guess = nil
    @saved_file = false
    File.open("saved_game.txt", "w") { |file| file.truncate(0) }
  end

  def play
    loop do
      display_guessed_letters
      break if game_over? || win?

      handle_player_input
      break if @saved_file

      handle_player_guess
    end
    @saved_file ? (puts "See you later!") : display_game_over_msg
  end

  def save_game
    data = {
      secret_word: @secret_word,
      guessed_letters: @guessed_letters,
      dashes: @dashes,
      lives_left: @lives_left
    }
    File.write("saved_game.txt", JSON.generate(data))
    puts "Game saved successfully!"
    @saved_file = !@saved_file
  end

  private

  def pick_random_word
    File.readlines("google-10000-english-no-swears.txt").select { |word| word.length.between?(6, 13) }.sample.chomp
  end

  def display_guessed_letters
    puts "\nThese are the letters you've tried: #{@guessed_letters}" unless @guessed_letters.empty?
    @dashes = @secret_word.chars.map do |char|
      @guessed_letters.include?(char) ? char : "_"
    end
    puts @dashes.join(" ")
  end

  def handle_player_input
    puts "\nEnter 'save' if you want to save and exit the game".colorize(:green)
    puts "You have #{lives_left} lives left. What letter do you want to guess?".colorize(:cyan)
    input = gets.chomp.downcase.strip
    input == "save" ? save_game : @current_guess = input[0]
  end

  def handle_player_guess
    loop do
      break unless @guessed_letters.include?(@current_guess)

      puts "You already guessed this letter, try again!".colorize(:magenta)
      @current_guess = gets.chomp.downcase.strip[0]
    end
    @guessed_letters << @current_guess
    incorrect_guess unless @secret_word.include?(@current_guess)
  end

  def incorrect_guess
    puts "This letter is not in the secret word, you lost a life :(".colorize(:magenta)
    @lives_left -= 1
  end

  def game_over?
    @lives_left.zero?
  end

  def win?
    !@dashes.include?("_")
  end

  def display_game_over_msg
    puts "\nCongratulations, you won!".colorize(:green) if win?
    puts "\nYou are out of lives :( The word was #{@secret_word}".colorize(:magenta) unless win?
  end
end
