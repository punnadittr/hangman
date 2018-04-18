require 'json'
class Hangman

  def initialize
    dict = File.readlines('dict.txt')
    dict.map! { |word| word.chomp }
    dict.select! { |word| word.length <= 12 }
    @rand_word = dict.sample.downcase
    @incorrect_guess = []
    @rounds = 8
  end

  def random_word
    @random_word = @rand_word.split('')
  end

  def create_display_spaces
    @guessing_spaces = Array.new(@random_word.length, '_')
  end

  def display_spaces
    @display_spaces = @guessing_spaces.join(' ')
  end

  def keep_track_input
    if @userinput == 'save' || @userinput == 'load'
      return
    elsif @userinput.length > 1 || @userinput.empty?
        puts 'Invalid Input'
    elsif (@random_word.include? @userinput) == false
      @incorrect_guess << @userinput.upcase
      @rounds -= 1
      @incorrect = true
    end
  end

  def game_over?
    if (@display_spaces.include? '_') == false
      puts 'You Win!'
      puts "The word is #{@rand_word.upcase}"
      @game_over = true
    elsif @rounds == 0
      puts 'You Lose!'
      puts "The word is #{@rand_word.upcase}"
      @game_over = true
    else
      @game_over = false
    end
  end

  def show_result
    if @incorrect == true && @rounds != 0
      puts "Incorrect: #{@incorrect_guess}" 
      puts "Rounds left: #{@rounds}"
    end
  end

  def play
    display_spaces
    while @game_over != true
      guess_word
    end
  end

  def save_load?
    save if @userinput == 'save'
    load if @userinput == 'load'
  end

  def guess_word
    puts display_spaces
    @userinput = gets.chomp
    save_load?
    @random_word.each_index do |i|
      if @random_word[i] == @userinput
        @guessing_spaces[i] = @random_word[i].upcase
      end
    end
    keep_track_input
    show_result
    display_spaces
    game_over?
    display_spaces
  end

  def save
    temp_hash = {}
    self.instance_variables.each do |var|
      temp_hash[var] = self.instance_variable_get var
    end
    File.open('save.json','w') do |f|
      f.write(temp_hash.to_json)
    end
    puts 'Game Saved!'
  end

  def load
    file = File.open('save.json', 'r')
    file_data = file.read
    JSON.load(file_data).each do |var, val|
        self.instance_variable_set var, val
    end
    puts 'Game Loaded!'
  end
end

game = Hangman.new
game.random_word
game.create_display_spaces
game.play