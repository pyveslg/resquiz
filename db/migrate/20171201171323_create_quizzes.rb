class CreateQuizzes < ActiveRecord::Migration[5.1]
  def change
    create_table :quizzes do |t|
      t.string :slug
      t.string :name
      t.string :path

      t.timestamps
    end
  end
end
