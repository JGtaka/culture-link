class StudyUnit < ApplicationRecord
  has_many :events, dependent: :restrict_with_error
  has_many :characters, dependent: :restrict_with_error
  has_many :study_unit_schedules, dependent: :restrict_with_error
  has_many :schedules, through: :study_unit_schedules

  before_validation :strip_name

  validates :name, presence: true, uniqueness: true

  private

  def strip_name
    self.name = name.strip if name.is_a?(String)
  end
end
