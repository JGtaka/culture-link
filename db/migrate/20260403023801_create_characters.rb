class CreateCharacters < ActiveRecord::Migration[7.2]
  def change
    create_table :characters do |t|
      t.string :name
      t.text :description
      t.text :achievement
      t.references :study_unit, null: false, foreign_key: true
    end
  end
end
