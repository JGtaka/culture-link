require 'rails_helper'

RSpec.describe QuizResult, type: :model do
  describe 'バリデーション' do
    it 'userとquizがあれば有効であること' do
      quiz_result = build(:quiz_result)
      expect(quiz_result).to be_valid
    end

    it 'userがなければ無効であること' do
      quiz_result = build(:quiz_result, user: nil)
      expect(quiz_result).not_to be_valid
    end

    it 'quizがなければ無効であること' do
      quiz_result = build(:quiz_result, quiz: nil)
      expect(quiz_result).not_to be_valid
    end

    it '同じuserとquizの組み合わせは重複できないこと' do
      existing = create(:quiz_result)
      duplicate = build(:quiz_result, user: existing.user, quiz: existing.quiz)
      expect(duplicate).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'userに属すること' do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq :belongs_to
    end

    it 'quizに属すること' do
      association = described_class.reflect_on_association(:quiz)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe 'enum status' do
    it 'in_progressとcompletedが定義されていること' do
      expect(QuizResult.statuses.keys).to contain_exactly('in_progress', 'completed')
    end
  end
end
