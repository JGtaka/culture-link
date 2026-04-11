class StudyUnitSchedule < ApplicationRecord
  belongs_to :schedule
  belongs_to :study_unit

  validates :study_unit_id, uniqueness: { scope: :schedule_id }
end
