require 'open-uri'
require 'json'

class GamesController < ApplicationController
  before_action :set_score, only: [:score]

  def new
    @letters = 10.times.map do
      ('A'..'Z').to_a.sample
    end
  end

  def score
    attempt = params[:word].upcase
    grid = params[:grid].split
    uri = URI.parse("https://dictionary.lewagon.com/#{attempt}").read
    @data = JSON.parse(uri)
    # The word can’t be built out of the original @letters ❌
    # The word is valid according to the @letters, but is not a valid English word ❌
    # The word is valid according to the @letters and is an English word ✅
    @result = {}
    if @data["found"] && attempt.chars.all? { |char| grid.include?(char) && attempt.count(char) <= grid.count(char) }
      @result[:message] = 'Well Done!'
      @result[:score] = @data["length"]
      session[:score] += @result[:score]
    else
      @result[:score] = 0
      @data["found"] ? @result[:message] = "Not in the grid!" : @result[:message] = "Not an english word"
    end
  end

  def set_score
    session[:score] = session[:score].nil? ? 0 : session[:score]
  end
end
