require 'rails_helper'

RSpec.describe Category, type: :model do
  describe 'バリデーション' do
    it 'nameがあれば有効であること' do
      category = build(:category)
      expect(category).to be_valid
    end

    it 'nameがなければ無効であること' do
      category = build(:category, name: nil)
      expect(category).not_to be_valid
    end

    it 'nameが空文字なら無効であること' do
      category = build(:category, name: '')
      expect(category).not_to be_valid
    end

    it 'nameが重複していたら無効であること' do
      create(:category, name: '絵画')
      category = build(:category, name: '絵画')
      expect(category).not_to be_valid
    end
  end
end
