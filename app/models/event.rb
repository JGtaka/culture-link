class Event < ApplicationRecord
  belongs_to :period
  belongs_to :category
  belongs_to :study_unit
  has_many :event_characters
  has_many :characters, through: :event_characters

  validates :title, presence: true
  validates :year, presence: true
  validates :description, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[title description]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
