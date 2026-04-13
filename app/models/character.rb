class Character < ApplicationRecord
  belongs_to :study_unit
  belongs_to :period
  belongs_to :region
  has_many :event_characters
  has_many :events, through: :event_characters
  has_many :favorites, as: :favorable, dependent: :destroy
  has_many :article_views, as: :article, dependent: :destroy

  validates :name, presence: true
  validates :description, presence: true
  validates :achievement, presence: true

  def self.ransackable_attributes(auth_object = nil)
    %w[name description achievement]
  end

  def self.ransackable_associations(auth_object = nil)
    []
  end
end
