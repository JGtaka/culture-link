require 'rails_helper'

RSpec.describe Event, type: :model do
  describe 'バリデーション' do
    it '全ての属性が正しければ有効であること' do
      event = build(:event)
      expect(event).to be_valid
    end

    it 'titleがなければ無効であること' do
      event = build(:event, title: nil)
      expect(event).not_to be_valid
    end

    it 'yearがなければ無効であること' do
      event = build(:event, year: nil)
      expect(event).not_to be_valid
    end

    it 'descriptionがなければ無効であること' do
      event = build(:event, description: nil)
      expect(event).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'periodに属すること' do
      association = described_class.reflect_on_association(:period)
      expect(association.macro).to eq :belongs_to
    end

    it 'categoryに属すること' do
      association = described_class.reflect_on_association(:category)
      expect(association.macro).to eq :belongs_to
    end

    it 'study_unitに属すること' do
      association = described_class.reflect_on_association(:study_unit)
      expect(association.macro).to eq :belongs_to
    end

    it '複数のevent_charactersを持つこと' do
      association = described_class.reflect_on_association(:event_characters)
      expect(association.macro).to eq :has_many
    end

    it '複数のcharactersをevent_characters経由で持つこと' do
      association = described_class.reflect_on_association(:characters)
      expect(association.macro).to eq :has_many
      expect(association.options[:through]).to eq :event_characters
    end
  end
end
