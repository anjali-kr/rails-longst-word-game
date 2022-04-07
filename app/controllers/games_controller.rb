require "open-uri"

class GamesController < ApplicationController
  def new
    alphabets = ('A'..'Z').to_a
    @letters = []
    10.times do
      @letters << alphabets.sample
    end
  end

  def score
    @word = params[:word]
    grid = params[:grid] # @letters
    # start_time = Time.now
    # end_time = Time.now

    @result = run_game(@word, grid)
  end

  def run_game(attempt, grid)
    # url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    # data_serialized = URI.open(url).read
    word_data = JSON.parse(URI.open("https://wagon-dictionary.herokuapp.com/#{attempt}").read)
    # word_data = JSON.parse(open(url).read)
    # word_data = JSON.parse(URI.parse(url).open)
    # binding.pry

    result = {}
    # result[:time] = end_time - start_time
    result[:score] = valid?(attempt, word_data, grid) ? compute_word_score(word_data) : 0
    result[:message] = compute_message(attempt, word_data, grid)
    result
  end

  def compute_message(attempt, word_data, grid)
    if !valid_word?(word_data)
      "Sorry, but <b>#{attempt.upcase}</b> is not a valid English word" # 'Not an english word'
    elsif !word_in_grid?(attempt.upcase, grid)
      "Sorry, but <b>#{attempt.upcase}</b> can't be build from #{grid}" # 'Word is not in the grid'
    else
      "<b>Congratulations!</b> #{attempt.upcase} is a valid english word."
    end
  end

  # compute score
  def compute_word_score(word_data) # , time_taken)
    word_data['length'] #+ (30 - time_taken)
  end

  # check if word is valid
  def valid?(word, word_data, grid)
    (valid_word?(word_data) && word_in_grid?(word.upcase, grid))
  end

  # check if all letters of the word are in the grid
  def word_in_grid?(word, grid)
    word.chars.all? { |char| word.count(char) <= grid.count(char) }
  end

  # check if word is a valid english word found in the dictionary
  def valid_word?(word_data)
    word_data['found']
  end
end
