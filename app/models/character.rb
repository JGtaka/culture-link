class Character < ApplicationRecord
  belongs_to :study_unit
  has_many :event_characters
  has_many :events, through: :event_characters

  validates :name, presence: true
  validates :description, presence: true
  validates :achievement, presence: true
end
