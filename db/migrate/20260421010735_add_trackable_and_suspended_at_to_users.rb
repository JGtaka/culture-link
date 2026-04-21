class AddTrackableAndSuspendedAtToUsers < ActiveRecord::Migration[7.2]
  def change
    add_column :users, :sign_in_count, :integer, default: 0, null: false
    add_column :users, :current_sign_in_at, :datetime
    add_column :users, :last_sign_in_at, :datetime
    add_column :users, :suspended_at, :datetime

    add_index :users, :current_sign_in_at
    add_index :users, :suspended_at
  end
end
