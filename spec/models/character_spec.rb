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
  end
end
