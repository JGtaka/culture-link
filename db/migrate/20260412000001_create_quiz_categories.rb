class CreateQuizCategories < ActiveRecord::Migration[7.2]
  def change
    create_table :quiz_categories do |t|
      t.string :name, null: false

      t.timestamps
    end

    add_index :quiz_categories, :name, unique: true
  end
end
