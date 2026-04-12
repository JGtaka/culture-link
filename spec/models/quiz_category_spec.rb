require 'rails_helper'

RSpec.describe QuizCategory, type: :model do
  describe 'バリデーション' do
    it 'nameがあれば有効であること' do
      quiz_category = build(:quiz_category)
      expect(quiz_category).to be_valid
    end

    it 'nameがなければ無効であること' do
      quiz_category = build(:quiz_category, name: nil)
      expect(quiz_category).not_to be_valid
    end

    it 'nameが重複していたら無効であること' do
      create(:quiz_category, name: 'ルネサンス')
      quiz_category = build(:quiz_category, name: 'ルネサンス')
      expect(quiz_category).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it '複数のquizzesを持つこと' do
      association = described_class.reflect_on_association(:quizzes)
      expect(association.macro).to eq :has_many
    end
  end
end
