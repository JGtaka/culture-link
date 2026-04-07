class AddImageCreditToEventsAndCharacters < ActiveRecord::Migration[7.2]
  def change
    add_column :events, :image_credit, :string
    add_column :characters, :image_credit, :string
  end
end
