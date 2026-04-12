require 'rails_helper'

RSpec.describe Choice, type: :model do
  describe 'バリデーション' do
    it 'bodyとquestionがあれば有効であること' do
      choice = build(:choice)
      expect(choice).to be_valid
    end

    it 'bodyがなければ無効であること' do
      choice = build(:choice, body: nil)
      expect(choice).not_to be_valid
    end

    it 'questionがなければ無効であること' do
      choice = build(:choice, question: nil)
      expect(choice).not_to be_valid
    end

    it 'correct_answerがnilなら無効であること' do
      choice = build(:choice, correct_answer: nil)
      expect(choice).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'questionに属すること' do
      association = described_class.reflect_on_association(:question)
      expect(association.macro).to eq :belongs_to
    end
  end
end
