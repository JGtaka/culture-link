class CreateQuizzes < ActiveRecord::Migration[7.2]
  def change
    create_table :quizzes do |t|
      t.string :title, null: false
      t.references :quiz_category, null: false, foreign_key: true
      t.string :image_url

      t.timestamps
    end
  end
end
