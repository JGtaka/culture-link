class Question < ApplicationRecord
  belongs_to :quiz
  has_many :choices, -> { order(:id) }, dependent: :destroy

  validates :body, presence: true
end
