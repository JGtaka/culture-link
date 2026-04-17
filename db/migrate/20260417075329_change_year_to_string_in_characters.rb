class ChangeYearToStringInCharacters < ActiveRecord::Migration[7.2]
  def up
    change_column :characters, :year, :string
  end

  def down
    change_column :characters, :year, :integer, using: "year::integer"
  end
end
