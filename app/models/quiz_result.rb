class QuizResult < ApplicationRecord
  belongs_to :user
  belongs_to :quiz
  has_many :question_answers, dependent: :destroy

  enum :status, { in_progress: 0, completed: 1 }

  validates :user_id, uniqueness: { scope: :quiz_id }
end
