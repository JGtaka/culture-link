class QuizCategory < ApplicationRecord
  has_many :quizzes, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
