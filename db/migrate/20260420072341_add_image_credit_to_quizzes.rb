class AddImageCreditToQuizzes < ActiveRecord::Migration[7.2]
  def change
    add_column :quizzes, :image_credit, :string
  end
end
