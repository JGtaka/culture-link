class QuizCategory < ApplicationRecord
  has_many :quizzes, dependent: :restrict_with_error

  scope :ordered, -> { order(:display_order, :id) }

  before_validation :set_default_display_order, on: :create

  validates :name, presence: true, uniqueness: true
  validates :display_order, presence: true, numericality: { only_integer: true }

  private

  def set_default_display_order
    self.display_order ||= (self.class.maximum(:display_order) || 0) + 1
  end
end
