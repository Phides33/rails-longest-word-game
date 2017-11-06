require 'open-uri'
require 'json'

class PagesController < ApplicationController
  # Méthodes qui devraient être dans le modèle
  def generate_grid(grid_size)
    Array.new(grid_size) { ('A'..'Z').to_a.sample }
  end

  def included?(guess, grid)
    guess.chars.all? { |letter| guess.count(letter) <= grid.count(letter) }
  end

  def english_word?(word)
    response = open("https://wagon-dictionary.herokuapp.com/#{word}")
    json = JSON.parse(response.read)
    return json['found']
  end

  def compute_score(attempt, time_taken)
    time_taken > 60.0 ? 0 : attempt.size * (1.0 - time_taken / 60.0)
  end

  def game
    @grid = generate_grid(9)
  end

  def score_and_message(attempt, grid, time)
    if included?(attempt.upcase, grid)
      if english_word?(attempt)
        @score_and_message = { score: compute_score(attempt, time), message: "well done" }
      else
        @score_and_message = { score: 0, message: "not an english word" }
      end
    else
      @score_and_message = { score: 0, message: "not in the grid" }
    end
  end

  def score
    @end_time = Time.now
    @result = { time: @end_time - params[:start_time].to_time }
    @score_and_message = score_and_message(params[:attempt], params[:grid], @result[:time])
    @result[:score] = @score_and_message[:score]
    @result[:message] = @score_and_message[:message]
  end
end

