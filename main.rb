puts "Let's play Hangman"

def pick_random_word
  File.readlines("google-10000-english-no-swears.txt").select { |word| word.length > 4 && word.length < 13 }.sample
end

puts pick_random_word
