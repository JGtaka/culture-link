class AddDisplayOrderToQuizCategories < ActiveRecord::Migration[7.2]
  def up
    add_column :quiz_categories, :display_order, :integer

    rows = execute("SELECT id FROM quiz_categories ORDER BY id ASC").to_a
    rows.each_with_index do |row, idx|
      id = row.is_a?(Hash) ? row["id"] : row[0]
      execute("UPDATE quiz_categories SET display_order = #{idx + 1} WHERE id = #{id}")
    end

    change_column_null :quiz_categories, :display_order, false
    add_index :quiz_categories, :display_order
  end

  def down
    remove_index :quiz_categories, :display_order
    remove_column :quiz_categories, :display_order
  end
end
