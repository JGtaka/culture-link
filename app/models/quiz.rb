class Quiz < ApplicationRecord
  belongs_to :quiz_category
  has_many :questions, -> { order(:id) }, dependent: :destroy
  has_many :quiz_results, dependent: :destroy

  has_one_attached :image
  validates :image, content_type: [ :png, :jpg, :jpeg, :webp ],
                    size: { less_than: 5.megabytes },
                    if: -> { image.attached? }

  validates :title, presence: true
  validate :must_have_questions_when_publishing

  scope :by_category, ->(category_id) { where(quiz_category_id: category_id) if category_id.present? }
  scope :published, -> { where.not(published_at: nil) }

  def published?
    published_at.present?
  end

  def status_for(user)
    return :new unless user

    quiz_results.find_by(user: user)&.status&.to_sym || :new
  end

  private

  def must_have_questions_when_publishing
    return if published_at.blank?
    return if questions.loaded? ? questions.reject(&:marked_for_destruction?).any? : questions.exists?

    errors.add(:base, "問題が1問もない小テストは公開できません")
  end
end
