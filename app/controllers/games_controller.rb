require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new

    @random_letters = ('A'..'Z').to_a.shuffle[0,8]

  end

  def score

    @result = run_game_light(params["word_submitted"], params["random_letters"].split("") )

  end

  private


  def generate_grid(grid_size)
    # TODO: generate random grid of letters
    Array.new(grid_size) { ('A'..'Z').to_a.sample(1) }
  end

  def attempt_include(attempt, grid)
    # TODO: runs the game and return detailed hash of result
    attempt.split('').all? do |letter|
      grid.include?(letter)
      grid.delete_at(grid.index(letter)) if grid.include?(letter)
    end
  end

  def attempt_is_english_word(attempt)
    # TODO: runs the game and return detailed hash of result
    url = "https://wagon-dictionary.herokuapp.com/#{attempt}"
    attempt_serialized = open(url).read
    return JSON.parse(attempt_serialized)
  end

  def run_game_light(attempt, grid)
    # TODO: runs the game and return detailed hash of result
    attempt_response = attempt_is_english_word(attempt.upcase)
    attempt_inc = attempt_include(attempt.upcase, grid)
    result = {}
    result[:time] = 0
    score = attempt.length * 2 - (result[:time]) * 0.5
    attempt_response['found'] && attempt_inc ? result[:score] = score : result[:score] = 0
    attempt_response['found'] && attempt_inc ? result[:message] = "well done" : result[:message] = 'not an english word'
    result[:message] = 'not in the grid' unless attempt_inc
    return result
  end

  def run_game(attempt, grid, start_time, end_time)
    # TODO: runs the game and return detailed hash of result
    attempt_response = attempt_is_english_word(attempt.upcase)
    attempt_inc = attempt_include(attempt.upcase, grid)
    result = {}
    result[:time] = end_time - start_time
    score = attempt.length * 2 - (result[:time]) * 0.5
    attempt_response['found'] && attempt_inc ? result[:score] = score : result[:score] = 0
    attempt_response['found'] && attempt_inc ? result[:message] = "well done" : result[:message] = 'not an english word'
    result[:message] = 'not in the grid' unless attempt_inc
    return result
  end

end
