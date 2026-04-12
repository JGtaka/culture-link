class Choice < ApplicationRecord
  belongs_to :question

  validates :body, presence: true
  validates :correct_answer, inclusion: { in: [ true, false ] }
end
