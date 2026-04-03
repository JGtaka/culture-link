class Event < ApplicationRecord
  belongs_to :period
  belongs_to :category
  belongs_to :study_unit
  has_many :event_characters
  has_many :characters, through: :event_characters

  validates :title, presence: true
  validates :year, presence: true
  validates :description, presence: true
end
