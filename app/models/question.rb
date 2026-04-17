class Question < ApplicationRecord
  belongs_to :quiz
  has_many :choices, -> { order(:id) }, dependent: :destroy

  has_many_attached :images
  validates :images, content_type: [ :png, :jpg, :jpeg, :webp ],
                     size: { less_than: 5.megabytes }

  validates :body, presence: true
end
