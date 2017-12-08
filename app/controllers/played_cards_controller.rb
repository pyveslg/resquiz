class PlayedCardsController < ApplicationController
  def create
    if PlayedCard.where("card_slug = ?", set_params[:card_slug]).empty?
      @played_card = PlayedCard.create!(set_params)
      redirect
    else
      update
    end
  end

  def delete
    @played_card = PlayedCard.where('deck_path =', self.set_params[:path] )
  end

  def update
    @played_card = PlayedCard.where("card_slug = ?", set_params[:card_slug]).first
    @played_card.update(set_params)
    redirect
  end

  private

  def set_params
     params.require(:played_card).permit(:card_slug, :guess, :deck_path, :mastered)
  end

  def reinsert_unmastered_cards_in_unplayed_cards
    @deck.unmastered_cards.each do |card|
      if card.card_slug == @selected_card.slug
        @unplayed_cards.push(@selected_card)
      end
    end
  end

  def redirect
    @deck = SetDeck.new.deck(@played_card.deck_path)
    @selected_card = @deck.find(@played_card.card_slug)
    @unplayed_cards = @deck.unplayed_cards
    reinsert_unmastered_cards_in_unplayed_cards
    @next_card = @unplayed_cards.shuffle.first
    if @next_card.nil?
      redirect_to decks_path
    else
      redirect_to flashcard_path(slug: @next_card.slug, path: @next_card.deck_path)
    end
  end
end
