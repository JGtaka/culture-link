class EventCharacter < ApplicationRecord
  belongs_to :event
  belongs_to :character

  validates :event_id, uniqueness: { scope: :character_id }
end
