require "rails_helper"

RSpec.describe QuestionAnswer, type: :model do
  describe "アソシエーション" do
    it "quiz_resultに属すること" do
      association = described_class.reflect_on_association(:quiz_result)
      expect(association.macro).to eq :belongs_to
    end

    it "questionに属すること" do
      association = described_class.reflect_on_association(:question)
      expect(association.macro).to eq :belongs_to
    end

    it "choiceに属すること" do
      association = described_class.reflect_on_association(:choice)
      expect(association.macro).to eq :belongs_to
    end
  end

  describe "バリデーション" do
    let(:quiz) { create(:quiz) }
    let(:question) { create(:question, quiz: quiz) }
    let(:choice) { create(:choice, question: question) }
    let(:quiz_result) { create(:quiz_result, quiz: quiz) }

    it "正常に作成できること" do
      qa = build(:question_answer, quiz_result: quiz_result, question: question, choice: choice)
      expect(qa).to be_valid
    end

    it "同じquiz_resultとquestionの組み合わせは一意であること" do
      create(:question_answer, quiz_result: quiz_result, question: question, choice: choice)
      duplicate = build(:question_answer, quiz_result: quiz_result, question: question, choice: choice)
      expect(duplicate).not_to be_valid
    end

    it "choiceが別のquestionに属している場合は無効であること" do
      other_question = create(:question, quiz: quiz)
      other_choice = create(:choice, question: other_question)
      qa = build(:question_answer, quiz_result: quiz_result, question: question, choice: other_choice)
      expect(qa).not_to be_valid
    end
  end
end
