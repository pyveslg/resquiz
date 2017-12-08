require 'deck'
require "open-uri"
require "json"
require "yaml"

class FlashcardsController < ApplicationController

  def show
    @deck = SetDeck.new.deck(params[:path])
    @selected_card = @deck.find(params[:slug])
    @unplayed_cards = @deck.unplayed_cards
    @played_card = PlayedCard.all.where(card_slug: @selected_card.slug).first
  end

end
