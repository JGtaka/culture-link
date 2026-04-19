require 'rails_helper'

RSpec.describe StudyUnit, type: :model do
  describe 'バリデーション' do
    it 'nameがあれば有効であること' do
      study_unit = build(:study_unit)
      expect(study_unit).to be_valid
    end

    it 'nameがなければ無効であること' do
      study_unit = build(:study_unit, name: nil)
      expect(study_unit).not_to be_valid
    end

    it 'nameが空文字なら無効であること' do
      study_unit = build(:study_unit, name: '')
      expect(study_unit).not_to be_valid
    end

    it 'nameが重複していたら無効であること' do
      create(:study_unit, name: 'ルネサンス')
      study_unit = build(:study_unit, name: 'ルネサンス')
      expect(study_unit).not_to be_valid
    end

    it 'nameの前後半角空白が自動除去されること' do
      study_unit = create(:study_unit, name: '  古代日本の文化  ')
      expect(study_unit.name).to eq('古代日本の文化')
    end

    it 'nameの前後全角空白が自動除去されること' do
      study_unit = create(:study_unit, name: '　古代日本の文化　')
      expect(study_unit.name).to eq('古代日本の文化')
    end

    it '前後空白違いで重複登録できないこと' do
      create(:study_unit, name: '古代日本の文化')
      study_unit = build(:study_unit, name: '　古代日本の文化 ')
      expect(study_unit).not_to be_valid
    end
  end

  describe '並び順' do
    it 'display_orderが未設定なら末尾に自動採番されること' do
      a = create(:study_unit)
      b = create(:study_unit)
      expect(b.display_order).to eq(a.display_order + 1)
    end

    it 'ordered scopeがdisplay_order昇順で返すこと' do
      s3 = create(:study_unit, display_order: 30)
      s1 = create(:study_unit, display_order: 10)
      s2 = create(:study_unit, display_order: 20)
      expect(StudyUnit.ordered.pluck(:id)).to eq([ s1.id, s2.id, s3.id ])
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
