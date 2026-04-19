class Region < ApplicationRecord
  has_many :events, dependent: :restrict_with_error
  has_many :characters, dependent: :restrict_with_error

  validates :name, presence: true, uniqueness: true
end
