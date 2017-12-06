class PlayedCardsController < ApplicationController
  def create
    @played_card = PlayedCard.create!(set_params)
    @deck = SetDeck.new(URL).deck(@played_card.deck_path)
    @unplayed_cards = @deck.unplayed_cards
    @next_card = @unplayed_cards.shuffle.first
    if @next_card.nil?
      redirect_to deck_path(@deck.path)
    else
      redirect_to flashcard_path(slug: @next_card.slug, path: @next_card.deck_path)
    end
  end

  def delete
    @played_card = PlayedCard.where('deck_path =', self.params[:path] )
  end

  private

  def set_params
     params.require(:played_card).permit(:card_slug, :choice, :deck_path)
  end

  CLIENT_ID = ENV['GH_BASIC_CLIENT_ID']
  CLIENT_SECRET = ENV['GH_BASIC_SECRET_ID']
  URL = "https://api.github.com/repos/pyveslg/MFE/contents/decks?client_id=#{CLIENT_ID}&client_secret=#{CLIENT_SECRET}"
end
