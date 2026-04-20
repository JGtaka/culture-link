class AddPublishedAtToQuizzes < ActiveRecord::Migration[7.2]
  def change
    add_column :quizzes, :published_at, :datetime
    add_index :quizzes, :published_at
  end
end
