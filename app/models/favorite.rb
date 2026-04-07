class Favorite < ApplicationRecord
  belongs_to :user
  belongs_to :favorable, polymorphic: true

  validates :user_id, uniqueness: { scope: [ :favorable_type, :favorable_id ] }
end
