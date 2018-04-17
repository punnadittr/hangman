require 'json'
class Hangman

  def initialize
    @dict = File.readlines('dict.txt')
    @dict.map! { |word| word.chomp }
    @dict.select! { |word| word.length <= 12 }
    @correct_guess = []
    @incorrect_guess = []
  end

  def random_word
    @random_word = @dict.sample.downcase.split('')
  end

  def create_display_spaces
    @guessing_spaces = Array.new(@random_word.length, '_')
  end

  def display_spaces
    @display_spaces = @guessing_spaces.join(' ')
  end

  def keep_track_input
    if @random_word.include? @userinput
      @correct_guess << @userinput.upcase
    else
      @incorrect_guess << @userinput
    end
  end

  def guess_word
    @userinput = gets.chomp
    @random_word.each_index do |i|
      if @random_word[i] == @userinput
        @guessing_spaces[i] = @random_word[i].upcase
      end
    end
    keep_track_input
    puts "Correct: #{@correct_guess}"
    puts "Incorrect: #{@incorrect_guess}"
    display_spaces
  end
end

game = Hangman.new
game.random_word
game.create_display_spaces
game.guess_word