require "colorize"
require "json"

class Game
  attr_reader :secret_word, :guessed_letters, :dashes, :lives_left, :current_guess, :saved_file

  def initialize
    if File.exist?("saved_game.json") && !File.empty?("saved_game.json")
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
    data = JSON.parse(File.read("saved_game.json"))
    @secret_word = data["secret_word"]
    @guessed_letters = data["guessed_letters"]
    @dashes = data["dashes"]
    @lives_left = data["lives_left"]
    @current_guess = nil
    @saved_file = false
    File.open("saved_game.json", "w") { |file| file.truncate(0) }
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
    File.write("saved_game.json", JSON.generate(data))
    puts "\nGame saved successfully!".colorize(:green)
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
    input = valid_input?
    input == "save" ? save_game : @current_guess = input[0]
  end

  def valid_input?
    loop do
      input = gets.chomp.downcase.strip
      if input.match?(/[a-z]/)
        return input unless input != "save" && @guessed_letters.include?(input[0])

        puts "You already guessed this letter, try again!".colorize(:magenta)
      else
        puts "Invalid input! Please enter a letter (a-z) or 'save'".colorize(:red)
      end
    end
  end

  def handle_player_guess
    @guessed_letters << @current_guess
    return incorrect_guess unless @secret_word.include?(@current_guess)

    puts "Good guess!".colorize(:green)
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
