class Event < ApplicationRecord
  belongs_to :period
  belongs_to :category
  belongs_to :study_unit

  validates :title, presence: true
  validates :year, presence: true
  validates :description, presence: true
end
