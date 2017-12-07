require 'deck'
require "open-uri"
require "json"
require "yaml"

class FlashcardsController < ApplicationController

  def show
    @deck = SetDeck.new(URL).deck(params[:path])
    @selected_card = @deck.find(params[:slug])
    @unplayed_cards = @deck.unplayed_cards
    @played_card = PlayedCard.all.where(card_slug: @selected_card.slug).first
  end

  private
  CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
  CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']
  URL = "https://api.github.com/repos/pyveslg/MFE/contents/decks?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}"

end
