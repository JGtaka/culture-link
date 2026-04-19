require 'rails_helper'

RSpec.describe Region, type: :model do
  describe 'バリデーション' do
    it 'nameがあれば有効であること' do
      region = build(:region)
      expect(region).to be_valid
    end

    it 'nameがなければ無効であること' do
      region = build(:region, name: nil)
      expect(region).not_to be_valid
    end

    it 'nameが空文字なら無効であること' do
      region = build(:region, name: '')
      expect(region).not_to be_valid
    end

    it 'nameが重複していたら無効であること' do
      create(:region, name: 'ヨーロッパ')
      region = build(:region, name: 'ヨーロッパ')
      expect(region).not_to be_valid
    end

    it 'nameの前後半角空白が自動除去されること' do
      region = create(:region, name: '  近畿  ')
      expect(region.name).to eq('近畿')
    end

    it 'nameの前後全角空白が自動除去されること' do
      region = create(:region, name: '　近畿　')
      expect(region.name).to eq('近畿')
    end

    it '前後空白違いで重複登録できないこと' do
      create(:region, name: '近畿')
      region = build(:region, name: '　近畿 ')
      expect(region).not_to be_valid
    end
  end

  describe '並び順' do
    it 'display_orderが未設定なら末尾に自動採番されること' do
      a = create(:region)
      b = create(:region)
      expect(b.display_order).to eq(a.display_order + 1)
    end

    it 'ordered scopeがdisplay_order昇順で返すこと' do
      r3 = create(:region, display_order: 30)
      r1 = create(:region, display_order: 10)
      r2 = create(:region, display_order: 20)
      expect(Region.ordered.pluck(:id)).to eq([ r1.id, r2.id, r3.id ])
    end
  end

  describe 'アソシエーション' do
    it '複数のeventsを持つこと' do
      association = described_class.reflect_on_association(:events)
      expect(association.macro).to eq :has_many
    end

    it '複数のcharactersを持つこと' do
      association = described_class.reflect_on_association(:characters)
      expect(association.macro).to eq :has_many
    end
  end
end
