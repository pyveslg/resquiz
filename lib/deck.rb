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
  end

  def deck(slug)
    file_content.each do |file|
      file["deck_slug"]
      return Deck.new(file["deck_slug"], file["deck_name"], file["path"], file["cards"]) if file["deck_slug"].include?(slug)
    end
    nil
  end

end
