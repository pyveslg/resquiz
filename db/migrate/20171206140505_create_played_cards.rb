class CreatePlayedCards < ActiveRecord::Migration[5.1]
  def change
    create_table :played_cards do |t|
      t.string :card_slug
      t.string :deck_path
      t.integer :choice

      t.timestamps
    end
  end
end
