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

  describe '.ordered' do
    it 'display_order順に返すこと' do
      c1 = create(:quiz_category, name: "A", display_order: 3)
      c2 = create(:quiz_category, name: "B", display_order: 1)
      c3 = create(:quiz_category, name: "C", display_order: 2)
      expect(QuizCategory.ordered).to eq([ c2, c3, c1 ])
    end
  end

  describe 'display_order自動採番' do
    it '新規作成時にdisplay_orderが自動でセットされること' do
      create(:quiz_category, name: "A")
      c2 = create(:quiz_category, name: "B")
      expect(c2.display_order).to be > 0
    end
  end
end
