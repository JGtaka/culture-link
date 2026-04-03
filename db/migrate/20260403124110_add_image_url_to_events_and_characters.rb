class AddImageUrlToEventsAndCharacters < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :image_url, :string
    add_column :characters, :image_url, :string
  end
end
