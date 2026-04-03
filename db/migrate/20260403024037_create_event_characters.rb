class CreateEventCharacters < ActiveRecord::Migration[7.2]
  def change
    create_table :event_characters do |t|
      t.references :event, null: false, foreign_key: true
      t.references :character, null: false, foreign_key: true
    end
    add_index :event_characters, [ :event_id, :character_id ], unique: true
  end
end
