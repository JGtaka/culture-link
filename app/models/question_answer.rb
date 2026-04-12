class QuestionAnswer < ApplicationRecord
  belongs_to :quiz_result
  belongs_to :question
  belongs_to :choice

  validates :question_id, uniqueness: { scope: :quiz_result_id }
  validate :choice_must_belong_to_question

  private

  def choice_must_belong_to_question
    return if choice.blank? || question.blank?

    errors.add(:choice, "は問題に属する選択肢を指定してください") if choice.question_id != question_id
  end
end
