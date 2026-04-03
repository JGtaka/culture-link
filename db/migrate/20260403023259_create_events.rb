class CreateEvents < ActiveRecord::Migration[7.2]
  def change
    create_table :events do |t|
      t.string :title
      t.integer :year
      t.references :period, null: false, foreign_key: true
      t.references :category, null: false, foreign_key: true
      t.text :description
      t.references :study_unit, null: false, foreign_key: true
    end
  end
end
