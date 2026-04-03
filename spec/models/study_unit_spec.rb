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
  end
end
