require 'rails_helper'

RSpec.describe Period, type: :model do
  describe 'バリデーション' do
    it 'nameがあれば有効であること' do
      period = build(:period)
      expect(period).to be_valid
    end

    it 'nameがなければ無効であること' do
      period = build(:period, name: nil)
      expect(period).not_to be_valid
    end

    it 'nameが空文字なら無効であること' do
      period = build(:period, name: '')
      expect(period).not_to be_valid
    end

    it 'nameが重複していたら無効であること' do
      create(:period, name: 'ルネサンス')
      period = build(:period, name: 'ルネサンス')
      expect(period).not_to be_valid
    end

    it 'nameの前後空白が自動除去されること' do
      period = create(:period, name: '  縄文時代  ')
      expect(period.name).to eq('縄文時代')
    end

    it '前後空白違いで重複登録できないこと' do
      create(:period, name: '縄文時代')
      period = build(:period, name: ' 縄文時代 ')
      expect(period).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it '複数のeventsを持つこと' do
      association = described_class.reflect_on_association(:events)
      expect(association.macro).to eq :has_many
    end
  end
end
