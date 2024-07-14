class Game
  attr_accessor :secret_word, :current_guess, :guessed_letters, :lives_left, :dashes

  def initialize
    @secret_word = nil
    @current_guess = nil
    @guessed_letters = []
    @lives_left = 8
    @dashes = []
  end

  def pick_random_word
    File.readlines("google-10000-english-no-swears.txt").select { |word| word.length > 4 && word.length < 13 }.sample.chomp # rubocop:disable Layout/LineLength
  end

  def play
    @secret_word = pick_random_word
    loop do
      display_guessed_letters
      break if game_over? || win?

      player_guess
    end
    display_game_over_msg
  end

  # def game_loop
  #   loop do
  #     display_guessed_letters
  #     player_guess
  #     break if game_over? || win?
  #   end
  # end

  def display_guessed_letters
    puts "\nThese are the letters you've tried: #{@guessed_letters}" unless @guessed_letters.empty?
    @dashes = @secret_word.chars.map do |char|
      @guessed_letters.include?(char) ? char : "_"
    end
    puts @dashes.join(" ")
  end

  def player_guess
    puts "\nYou have #{lives_left} lives left. What letter do you want to guess?"
    loop do
      @current_guess = gets.chomp.downcase.strip[0]
      break unless @guessed_letters.include?(@current_guess)

      puts "You already guessed this letter, try again!"
    end
    @guessed_letters << @current_guess
    incorrect_guess unless @secret_word.include?(@current_guess)
  end

  def incorrect_guess
    puts "This letter is not in the secret word, you lost a life :("
    @lives_left -= 1
  end

  def game_over?
    @lives_left.zero?
  end

  def win?
    !@dashes.include?("_")
  end

  def display_game_over_msg
    puts "Congratulations, you won!" if win?
    puts "You lost :( The word was #{@secret_word}" unless win?
  end
end
