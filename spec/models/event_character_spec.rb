require 'rails_helper'

RSpec.describe EventCharacter, type: :model do
  describe 'アソシエーション' do
    it 'eventに属すること' do
      association = described_class.reflect_on_association(:event)
      expect(association.macro).to eq :belongs_to
    end

    it 'characterに属すること' do
      association = described_class.reflect_on_association(:character)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'バリデーション' do
    it '全ての属性が正しければ有効であること' do
      event_character = build(:event_character)
      expect(event_character).to be_valid
    end

    it 'eventとcharacterの組み合わせが重複していたら無効であること' do
      event = create(:event)
      character = create(:character)
      create(:event_character, event: event, character: character)
      event_character = build(:event_character, event: event, character: character)
      expect(event_character).not_to be_valid
    end
  end
end
