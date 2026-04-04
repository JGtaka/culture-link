class Region < ApplicationRecord
  has_many :events
  has_many :characters

  validates :name, presence: true, uniqueness: true
end
