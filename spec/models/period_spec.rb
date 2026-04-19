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

    it 'nameの前後半角空白が自動除去されること' do
      period = create(:period, name: '  縄文時代  ')
      expect(period.name).to eq('縄文時代')
    end

    it 'nameの前後全角空白が自動除去されること' do
      period = create(:period, name: '　縄文時代　')
      expect(period.name).to eq('縄文時代')
    end

    it 'nameのタブ・改行も自動除去されること' do
      period = create(:period, name: "\t縄文時代\n")
      expect(period.name).to eq('縄文時代')
    end

    it '前後空白違いで重複登録できないこと' do
      create(:period, name: '縄文時代')
      period = build(:period, name: '　縄文時代 ')
      expect(period).not_to be_valid
    end
  end

  describe '並び順' do
    it 'display_orderが未設定なら末尾に自動採番されること' do
      a = create(:period)
      b = create(:period)
      c = create(:period)
      expect([ a.display_order, b.display_order, c.display_order ]).to eq([ a.display_order, a.display_order + 1, a.display_order + 2 ])
    end

    it 'display_orderを指定すれば優先されること' do
      period = create(:period, display_order: 99)
      expect(period.display_order).to eq(99)
    end

    it 'ordered scopeがdisplay_order昇順で返すこと' do
      p3 = create(:period, display_order: 30)
      p1 = create(:period, display_order: 10)
      p2 = create(:period, display_order: 20)
      expect(Period.ordered.pluck(:id)).to eq([ p1.id, p2.id, p3.id ])
    end
  end

  describe 'アソシエーション' do
    it '複数のeventsを持つこと' do
      association = described_class.reflect_on_association(:events)
      expect(association.macro).to eq :has_many
    end
  end
end
