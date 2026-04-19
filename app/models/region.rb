class Region < ApplicationRecord
  has_many :events, dependent: :restrict_with_error
  has_many :characters, dependent: :restrict_with_error

  scope :ordered, -> { order(:display_order, :id) }

  before_validation :strip_name
  before_validation :set_default_display_order, on: :create

  validates :name, presence: true, uniqueness: true
  validates :display_order, presence: true, numericality: { only_integer: true }

  private

  def strip_name
    self.name = name.gsub(/\A\p{Space}+|\p{Space}+\z/, "") if name.is_a?(String)
  end

  def set_default_display_order
    self.display_order ||= (self.class.maximum(:display_order) || 0) + 1
  end
end
