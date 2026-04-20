class Question < ApplicationRecord
  CHOICES_COUNT = 4

  belongs_to :quiz
  has_many :choices, -> { order(:id) }, dependent: :destroy
  has_many :question_answers, dependent: :destroy
  accepts_nested_attributes_for :choices, allow_destroy: false

  has_many_attached :images
  validates :images, content_type: [ :png, :jpg, :jpeg, :webp ],
                     size: { less_than: 5.megabytes }

  validates :body, presence: true

  attr_writer :correct_choice_index

  def correct_choice_index
    return @correct_choice_index if defined?(@correct_choice_index)

    idx = choices.to_a.index(&:correct_answer)
    idx&.to_s
  end

  validates :correct_choice_index,
            presence: { message: "を1つ選択してください" },
            inclusion: { in: %w[0 1 2 3], message: "が不正です" },
            if: :correct_choice_index_required?

  validate :must_have_four_choices
  before_validation :apply_correct_choice

  private

  def correct_choice_index_required?
    correct_choice_index.present? || choices.any? { |c| c.body.present? }
  end

  def must_have_four_choices
    valid_choices = choices.reject(&:marked_for_destruction?)
    return if valid_choices.empty?

    errors.add(:choices, "は#{CHOICES_COUNT}つ必要です") if valid_choices.size != CHOICES_COUNT
  end

  def apply_correct_choice
    return if correct_choice_index.blank?

    i = correct_choice_index.to_i
    choices.each_with_index do |choice, idx|
      choice.correct_answer = (idx == i)
    end
  end
end
