class AddColumnsToCharacters < ActiveRecord::Migration[7.2]
  def change
    add_column :characters, :year, :integer
    add_reference :characters, :period, foreign_key: true
    add_reference :characters, :region, foreign_key: true
  end
end
