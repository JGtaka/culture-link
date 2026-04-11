class StudyUnit < ApplicationRecord
  has_many :events
  has_many :characters
  has_many :study_unit_schedules
  has_many :schedules, through: :study_unit_schedules

  validates :name, presence: true, uniqueness: true
end
