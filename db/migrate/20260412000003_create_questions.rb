class CreateQuestions < ActiveRecord::Migration[7.2]
  def change
    create_table :questions do |t|
      t.references :quiz, null: false, foreign_key: true
      t.text :body, null: false

      t.timestamps
    end
  end
end
