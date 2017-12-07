class AddGuessToPlayedCards < ActiveRecord::Migration[5.1]
  def change
    add_column :played_cards, :guess, :string
    remove_column :played_cards, :choice
    add_column :played_cards, :mastered, :boolean
  end
end
