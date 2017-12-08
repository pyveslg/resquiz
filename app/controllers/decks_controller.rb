require 'deck'
require "open-uri"
require "json"
require "yaml"

class DecksController < ApplicationController
  def index
    @decks = SetDeck.new.all
  end

  def show
    @deck = SetDeck.new.deck(params[:path])
    @cards = @deck.set_card
    @played_cards = @deck.played_cards
    @unplayed_cards = @deck.unplayed_cards ## Il nous faudra juste le trier .sort
    @next_card = @unplayed_cards.shuffle.first
    flashcard_path(slug: @cards.first.slug, path: @cards.first.deck_path)
    if !@next_card.nil?
      if @played_cards.empty?
        redirect_to flashcard_path(slug: @cards.first.slug, path: @cards.first.deck_path)
      else
        redirect_to flashcard_path(slug: @next_card.slug, path: @next_card.deck_path)
      end
    end

  end

  def replay
    @deck = SetDeck.new.deck(params[:path])
    @deck.delete_played_cards
    redirect_to flashcard_path(slug: @deck.set_card.first.slug, path: @deck.set_card.first.deck_path)
  end


end
