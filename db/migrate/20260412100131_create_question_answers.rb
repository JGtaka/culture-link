class CreateQuestionAnswers < ActiveRecord::Migration[7.2]
  def change
    create_table :question_answers do |t|
      t.references :quiz_result, null: false, foreign_key: true
      t.references :question, null: false, foreign_key: true
      t.references :choice, null: false, foreign_key: true
      t.boolean :is_correct, null: false, default: false
      t.timestamps
    end
    add_index :question_answers, [ :quiz_result_id, :question_id ], unique: true
  end
end
