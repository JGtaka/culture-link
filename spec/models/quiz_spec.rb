require 'rails_helper'

RSpec.describe Quiz, type: :model do
  describe 'バリデーション' do
    it 'titleとquiz_categoryがあれば有効であること' do
      quiz = build(:quiz)
      expect(quiz).to be_valid
    end

    it 'titleがなければ無効であること' do
      quiz = build(:quiz, title: nil)
      expect(quiz).not_to be_valid
    end

    it 'quiz_categoryがなければ無効であること' do
      quiz = build(:quiz, quiz_category: nil)
      expect(quiz).not_to be_valid
    end
  end

  describe 'アソシエーション' do
    it 'quiz_categoryに属すること' do
      association = described_class.reflect_on_association(:quiz_category)
      expect(association.macro).to eq :belongs_to
    end

    it '複数のquestionsを持つこと' do
      association = described_class.reflect_on_association(:questions)
      expect(association.macro).to eq :has_many
    end

    it '複数のquiz_resultsを持つこと' do
      association = described_class.reflect_on_association(:quiz_results)
      expect(association.macro).to eq :has_many
    end
  end

  describe '.by_category' do
    let!(:category_a) { create(:quiz_category, name: 'ルネサンス') }
    let!(:category_b) { create(:quiz_category, name: 'バロック') }
    let!(:quiz_a) { create(:quiz, quiz_category: category_a) }
    let!(:quiz_b) { create(:quiz, quiz_category: category_b) }

    it 'カテゴリIDで絞り込みできること' do
      expect(Quiz.by_category(category_a.id)).to contain_exactly(quiz_a)
    end

    it 'カテゴリIDが空なら全件返すこと' do
      expect(Quiz.by_category(nil)).to contain_exactly(quiz_a, quiz_b)
    end
  end

  describe '.published' do
    let!(:published_quiz) do
      quiz = create(:quiz)
      create(:question, quiz: quiz)
      quiz.update!(published_at: 1.day.ago)
      quiz
    end
    let!(:draft_quiz) { create(:quiz, published_at: nil) }

    it '公開中の小テストのみ返すこと' do
      expect(Quiz.published).to contain_exactly(published_quiz)
    end
  end

  describe '#published?' do
    it 'published_atが設定されていればtrueを返すこと' do
      expect(build(:quiz, published_at: Time.current).published?).to be true
    end

    it 'published_atがnilならfalseを返すこと' do
      expect(build(:quiz, published_at: nil).published?).to be false
    end
  end

  describe '公開バリデーション' do
    it '問題が1件もない状態では公開できないこと' do
      quiz = create(:quiz)
      quiz.published_at = Time.current
      expect(quiz).not_to be_valid
      expect(quiz.errors[:base]).to include(/問題が1問もない/)
    end

    it '問題が1件以上あれば公開できること' do
      quiz = create(:quiz)
      create(:question, quiz: quiz)
      quiz.published_at = Time.current
      expect(quiz).to be_valid
    end
  end

  describe '#status_for' do
    let(:user) { create(:user) }
    let(:quiz) { create(:quiz) }

    it 'userがnilなら:newを返すこと' do
      expect(quiz.status_for(nil)).to eq :new
    end

    it 'quiz_resultが存在しないなら:newを返すこと' do
      expect(quiz.status_for(user)).to eq :new
    end

    it 'quiz_resultが進行中なら:in_progressを返すこと' do
      create(:quiz_result, user: user, quiz: quiz, status: :in_progress)
      expect(quiz.status_for(user)).to eq :in_progress
    end

    it 'quiz_resultが完了なら:completedを返すこと' do
      create(:quiz_result, user: user, quiz: quiz, status: :completed)
      expect(quiz.status_for(user)).to eq :completed
    end
  end
end
