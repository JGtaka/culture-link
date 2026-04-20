class Choice < ApplicationRecord
  belongs_to :question
  has_many :question_answers, dependent: :destroy

  validates :body, presence: true
  validates :correct_answer, inclusion: { in: [ true, false ] }
end
