require 'deck'
require "open-uri"
require "json"
require "yaml"

class DecksController < ApplicationController
  def index
    @decks = SetDeck.new(URL).all
  end

  def show
    @deck = SetDeck.new(URL).deck("terminal-and-git")
  end

  private
  CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
  CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']
  URL = "https://api.github.com/repos/pyveslg/MFE/contents/decks?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}"

end
