require 'open-uri'
require 'json'

class GamesController < ApplicationController
  def new
    @grid = Array.new(9) { Array('A'..'Z').sample }
  end

  def score
    url = "https://wagon-dictionary.herokuapp.com/#{params[:answer]}"

    word_serialization = URI.open(url).read
    word = JSON.parse(word_serialization)

    # change the attempt to upcase for comparison purposes and then into an array
    attempt_array = params[:answer].upcase.chars
    # finding the intersection didn't use subset since it does not return the duplicated item twice
    intersection = (attempt_array & params[:grid].split(' ')).flat_map { |n| [n] * [attempt_array.count(n), params[:grid].count(n)].min }
    # sorting it so that the array is in the same order to compare
    # when two identical arrays in a different order is compared it return false
    in_grid = intersection.sort == attempt_array.sort

    is_valid = word['found']

    @message = 'Well Done!'
    @message = 'Oops! not an english word' unless is_valid
    @message = 'Sorry! not in the grid' unless in_grid
  end
end
