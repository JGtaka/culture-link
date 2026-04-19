class AddDisplayOrderToMasters < ActiveRecord::Migration[7.2]
  def up
    add_column :periods, :display_order, :integer
    add_column :regions, :display_order, :integer
    add_column :study_units, :display_order, :integer

    backfill_display_order(:periods)
    backfill_display_order(:regions)
    backfill_display_order(:study_units)

    change_column_null :periods, :display_order, false
    change_column_null :regions, :display_order, false
    change_column_null :study_units, :display_order, false

    add_index :periods, :display_order
    add_index :regions, :display_order
    add_index :study_units, :display_order
  end

  def down
    remove_index :periods, :display_order
    remove_index :regions, :display_order
    remove_index :study_units, :display_order

    remove_column :periods, :display_order
    remove_column :regions, :display_order
    remove_column :study_units, :display_order
  end

  private

  def backfill_display_order(table)
    rows = execute("SELECT id FROM #{table} ORDER BY id ASC").to_a
    rows.each_with_index do |row, idx|
      id = row.is_a?(Hash) ? row["id"] : row[0]
      execute("UPDATE #{table} SET display_order = #{idx + 1} WHERE id = #{id}")
    end
  end
end
