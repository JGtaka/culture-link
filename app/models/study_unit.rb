class StudyUnit < ApplicationRecord
  has_many :events, dependent: :restrict_with_error
  has_many :characters, dependent: :restrict_with_error
  has_many :study_unit_schedules, dependent: :destroy
  has_many :schedules, through: :study_unit_schedules

  validates :name, presence: true, uniqueness: true
end
