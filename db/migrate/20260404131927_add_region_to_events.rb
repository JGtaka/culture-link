class AddRegionToEvents < ActiveRecord::Migration[7.2]
  def change
    add_reference :events, :region, foreign_key: true
  end
end
