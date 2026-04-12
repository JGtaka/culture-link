class AddImageColumnsToQuestions < ActiveRecord::Migration[7.2]
  def change
    add_column :questions, :image_url, :string
    add_column :questions, :image_credit, :string
  end
end
