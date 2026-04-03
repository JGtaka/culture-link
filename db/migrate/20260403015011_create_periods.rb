class CreatePeriods < ActiveRecord::Migration[7.2]
  def change
    create_table :periods do |t|
      t.string :name
    end
  end
end
