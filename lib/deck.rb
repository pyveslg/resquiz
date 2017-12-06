require "redcarpet"
require_relative "./deep_symbolize"

class SetDeck
  def initialize(url)
    @url = url
  end

  def file_content
    json_content = JSON.parse(open(@url).read)
    decks = []
    json_content.each_with_index do |deck, i|
      file_content_url = json_content[i]['download_url']
      yml_content = open(file_content_url).read
      file_content = YAML.load(yml_content)
      decks.push(file_content)
    end
    decks
  end

  def all
    total = []
    file_content.each do |deck|
      deck_slug = deck["deck_slug"]
      deck_name = deck["deck_name"]
      path = deck["path"]
      cards = deck["cards"]
      total.push(Deck.new(deck_slug, deck_name, path, cards))
    end
    total
  end


  class Deck
    def initialize(deck_slug, deck_name, path, cards)
      @deck_slug = deck_slug
      @deck_name = deck_name
      @path = path
      @cards = cards
    end

    def slug
      @deck_slug
    end

    def name
      @deck_name
    end

    def path
      @path
    end

    def cards
      @cards
    end

    def set_card
      cards = []
      self.cards.each_with_index do |card, index|
        cards.push(Card.new(index, self.path, card["slug"], card["key_concept"], card["front"], card["back"]))
      end
      return cards
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
          if card.card_slug == carte.slug
            @unplayed_cards.delete(carte)
          end
        end
      end
      return @unplayed_cards
    end

    def score
      played_cards.length
      set_card.length
      if !played_cards.empty?
        return played_cards.length.fdiv(set_card.length)*100
      else
        return played_cards.length
      end
    end

    def delete_played_cards
      self.played_cards.destroy_all
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
    file_content.each do |file|
      return Deck.new(file["deck_slug"], file["deck_name"], file["path"], file["cards"]) if file["path"].include?(path)
    end
    nil
  end

end
