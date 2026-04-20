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

  describe '4択固定バリデーション' do
    let(:quiz) { create(:quiz) }

    it '選択肢が4つあれば有効であること' do
      question = build(:question, quiz: quiz, correct_choice_index: "0")
      4.times { |i| question.choices.build(body: "選択肢#{i + 1}") }
      expect(question).to be_valid
    end

    it '選択肢が3つ以下なら無効であること' do
      question = build(:question, quiz: quiz, correct_choice_index: "0")
      3.times { |i| question.choices.build(body: "選択肢#{i + 1}") }
      expect(question).not_to be_valid
      expect(question.errors[:choices]).to include(/4つ/)
    end

    it '選択肢が5つ以上なら無効であること' do
      question = build(:question, quiz: quiz, correct_choice_index: "0")
      5.times { |i| question.choices.build(body: "選択肢#{i + 1}") }
      expect(question).not_to be_valid
      expect(question.errors[:choices]).to include(/4つ/)
    end
  end

  describe 'correct_choice_index仮想属性' do
    let(:quiz) { create(:quiz) }

    it 'submit時に指定indexの選択肢だけがcorrect_answerになること' do
      question = build(:question, quiz: quiz, correct_choice_index: "2")
      4.times { |i| question.choices.build(body: "選択肢#{i + 1}") }
      question.save!
      expect(question.choices.map(&:correct_answer)).to eq [ false, false, true, false ]
    end

    it 'correct_choice_indexが空なら無効であること' do
      question = build(:question, quiz: quiz, correct_choice_index: nil)
      4.times { |i| question.choices.build(body: "選択肢#{i + 1}") }
      expect(question).not_to be_valid
      expect(question.errors[:correct_choice_index]).to be_present
    end

    it 'correct_choice_indexが範囲外(4以上)なら無効であること' do
      question = build(:question, quiz: quiz, correct_choice_index: "4")
      4.times { |i| question.choices.build(body: "選択肢#{i + 1}") }
      expect(question).not_to be_valid
    end
  end
end
