require 'rails_helper'

RSpec.describe Question, type: :model do
  describe 'バリデーション' do
    it 'bodyとquizがあれば有効であること' do
      question = build(:question)
      expect(question).to be_valid
    end

    it 'bodyがなければ無効であること' do
      question = build(:question, body: nil)
      expect(question).not_to be_valid
    end

    it 'quizがなければ無効であること' do
      question = build(:question, quiz: nil)
      expect(question).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'quizに属すること' do
      association = described_class.reflect_on_association(:quiz)
      expect(association.macro).to eq :belongs_to
    end

    it '複数のchoicesを持つこと' do
      association = described_class.reflect_on_association(:choices)
      expect(association.macro).to eq :has_many
    end
  end
end
