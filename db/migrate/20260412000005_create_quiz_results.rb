class CreateQuizResults < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_results do |t|
      t.references :user, null: false, foreign_key: true
      t.references :quiz, null: false, foreign_key: true
      t.integer :status, null: false, default: 0
      t.integer :score
      t.integer :correct_count
      t.integer :total_correct
      t.date :test_date

      t.timestamps
    end

    add_index :quiz_results, [ :user_id, :quiz_id ], unique: true
  end
end
