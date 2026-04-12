class Quiz < ApplicationRecord
  belongs_to :quiz_category
  has_many :questions, -> { order(:id) }, dependent: :destroy
  has_many :quiz_results, dependent: :destroy

  validates :title, presence: true

  scope :by_category, ->(category_id) { where(quiz_category_id: category_id) if category_id.present? }

  def status_for(user)
    return :new unless user

    quiz_results.find_by(user: user)&.status&.to_sym || :new
  end
end
