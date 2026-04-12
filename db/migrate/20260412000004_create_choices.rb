class CreateChoices < ActiveRecord::Migration[7.2]
  def change
    create_table :choices do |t|
      t.references :question, null: false, foreign_key: true
      t.string :body, null: false
      t.boolean :correct_answer, null: false, default: false

      t.timestamps
    end
  end
end
