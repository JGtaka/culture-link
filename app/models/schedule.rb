class Schedule < ApplicationRecord
  belongs_to :user
  has_many :study_unit_schedules, dependent: :destroy
  has_many :study_units, through: :study_unit_schedules

  validates :start_date, presence: true
  validates :end_date, presence: true
  validates :daily_study_hours, presence: true,
    numericality: { only_integer: true, greater_than: 0, less_than_or_equal_to: 12 }
  validate :end_date_after_start_date

  def weekdays=(values)
    super(Array(values).compact_blank)
  end

  private

  def end_date_after_start_date
    return if start_date.blank? || end_date.blank?

    if end_date <= start_date
      errors.add(:end_date, "は開始日より後の日付にしてください")
    end
  end
end
