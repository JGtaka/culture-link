require 'rails_helper'

RSpec.describe Character, type: :model do
  describe 'バリデーション' do
    it '全ての属性が正しければ有効であること' do
      character = build(:character)
      expect(character).to be_valid
    end

    it 'nameがなければ無効であること' do
      character = build(:character, name: nil)
      expect(character).not_to be_valid
    end

    it 'descriptionがなければ無効であること' do
      character = build(:character, description: nil)
      expect(character).not_to be_valid
    end

    it 'achievementがなければ無効であること' do
      character = build(:character, achievement: nil)
      expect(character).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'study_unitに属すること' do
      association = described_class.reflect_on_association(:study_unit)
      expect(association.macro).to eq :belongs_to
    end

    it 'periodに属すること' do
      association = described_class.reflect_on_association(:period)
      expect(association.macro).to eq :belongs_to
    end

    it 'regionに属すること' do
      association = described_class.reflect_on_association(:region)
      expect(association.macro).to eq :belongs_to
    end

    it '複数のevent_charactersを持つこと' do
      association = described_class.reflect_on_association(:event_characters)
      expect(association.macro).to eq :has_many
    end

    it '複数のeventsをevent_characters経由で持つこと' do
      association = described_class.reflect_on_association(:events)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :event_characters
    end
  end
end
