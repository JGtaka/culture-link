class Character < ApplicationRecord
  belongs_to :study_unit

  validates :name, presence: true
  validates :description, presence: true
  validates :achievement, presence: true
end
