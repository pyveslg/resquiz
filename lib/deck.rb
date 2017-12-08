require "redcarpet"
require_relative "./deep_symbolize"

class SetDeck
  class Deck
    def initialize(file)
      @file = load_file(file)
    end

    def slug
      @deck_slug = @file[:deck_slug]
    end

    def name
      @deck_name = @file[:deck_name]
    end

    def path
      @path = @file[:path]
    end

    def cards
      @cards = @file[:cards]
    end

    def set_card
      cartes = []
      self.cards.each_with_index do |card, index|
        cartes.push(Card.new(index, self.path, card[:slug], card[:key_concept], card[:front], card[:back]))
      end
      return cartes
    end

    def find(card_slug)
      self.set_card.find {|card| card.slug == card_slug}
    end

    def played_cards
      @played_cards = PlayedCard.all.where(deck_path: self.path)
    end

    def unplayed_cards
      @unplayed_cards = self.set_card
      self.played_cards.each do |card|
        @unplayed_cards.each do |carte|
          if card.card_slug == carte.slug && card.mastered == true

            @unplayed_cards.delete(carte)
          end
        end
      end
      return @unplayed_cards
    end

    def mastered_cards
      @mastered_cards = PlayedCard.all.where("deck_path = ? and mastered", self.path)
    end

    def unmastered_cards
      @unmastered_cards = PlayedCard.all.where("deck_path = ? and mastered = ?", self.path, false)
    end

    def score
      (self.mastered_cards.length.fdiv(self.set_card.length)*100).ceil
    end

    def delete_played_cards
      self.played_cards.destroy_all
    end

    private

    def load_file(file)
      hash = YAML::load_file(file)
      hash.extend DeepSymbolizable
      hash.deep_symbolize { |key| key }
    end

    class Card
      def initialize(index, deck_path, slug, key_concept, front, back)
        @index = index.to_i
        @deck_path = deck_path
        @slug = slug
        @key_concept = key_concept
        @front = front
        @back = back
      end

      def index
        @index
      end
      def slug
        @slug
      end

      def key_concept
        @key_concept
      end

      def front
        markdown.render(@front)
      end

      def back
        markdown.render(@back)
      end

      def deck_path
        @deck_path
      end

      def markdown
        @markdown ||= (
          Redcarpet::Markdown.new(PygmentizeHTML, fenced_code_blocks: true )
        )
      end

      class PygmentizeHTML < Redcarpet::Render::HTML
        def initialize(extensions = {})
          super extensions.merge(link_attributes: { target: "_blank" })
        end

        def block_code(code, language)
          language = :javascript if language == "json"
          language = :bash unless language
          require 'pygmentize'
          Pygmentize.process(code, language)
        end
      end

    end
  end

  def deck(path)
    selected_deck = []
    all.each do |deck|
      if deck.path == path
        selected_deck.push(deck)
      end
    end
    selected_deck.first
  end

  def all
    files.map do |file|
      Deck.new(file)
    end
  end

  private

  def files
    Dir["#{File.dirname(__FILE__)}/../flashcards/fbp/*.yml"]
  end


end
