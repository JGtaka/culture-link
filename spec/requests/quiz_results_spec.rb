require "rails_helper"

RSpec.describe "QuizResults", type: :request do
  let(:user) { create(:user) }
  let(:quiz) { create(:quiz, title: "ルネサンスのテスト") }
  let!(:question1) { create(:question, body: "Q1", quiz: quiz) }
  let!(:q1_correct) { create(:choice, body: "フィレンツェ", correct_answer: true, question: question1) }
  let!(:q1_wrong) { create(:choice, body: "ローマ", correct_answer: false, question: question1) }
  let!(:question2) { create(:question, body: "Q2", quiz: quiz) }
  let!(:q2_correct) { create(:choice, body: "ダ・ヴィンチ", correct_answer: true, question: question2) }
  let!(:q2_wrong) { create(:choice, body: "ミケランジェロ", correct_answer: false, question: question2) }

  describe "POST /quiz_results" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        post quiz_results_path, params: { quiz_id: quiz.id, answers: { question1.id.to_s => q1_correct.id.to_s } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "ログイン済みの場合" do
      before { sign_in user }

      context "全問正解" do
        let(:valid_params) do
          {
            quiz_id: quiz.id,
            answers: {
              question1.id.to_s => q1_correct.id.to_s,
              question2.id.to_s => q2_correct.id.to_s
            }
          }
        end

        it "QuizResultが作成される" do
          expect { post quiz_results_path, params: valid_params }.to change(QuizResult, :count).by(1)
        end

        it "QuestionAnswerが問題数分作成される" do
          expect { post quiz_results_path, params: valid_params }.to change(QuestionAnswer, :count).by(2)
        end

        it "スコアが100になる" do
          post quiz_results_path, params: valid_params
          expect(QuizResult.last.score).to eq(100)
        end

        it "correct_countが問題数と一致する" do
          post quiz_results_path, params: valid_params
          expect(QuizResult.last.correct_count).to eq(2)
        end

        it "statusがcompletedになる" do
          post quiz_results_path, params: valid_params
          expect(QuizResult.last.status).to eq("completed")
        end

        it "結果画面にリダイレクトされる" do
          post quiz_results_path, params: valid_params
          expect(response).to redirect_to(quiz_result_path(QuizResult.last))
        end

        it "test_dateが今日" do
          post quiz_results_path, params: valid_params
          expect(QuizResult.last.test_date).to eq(Date.current)
        end
      end

      context "半分正解" do
        let(:mixed_params) do
          {
            quiz_id: quiz.id,
            answers: {
              question1.id.to_s => q1_correct.id.to_s,
              question2.id.to_s => q2_wrong.id.to_s
            }
          }
        end

        it "スコアが50になる" do
          post quiz_results_path, params: mixed_params
          expect(QuizResult.last.score).to eq(50)
        end

        it "correct_countが1" do
          post quiz_results_path, params: mixed_params
          expect(QuizResult.last.correct_count).to eq(1)
        end

        it "不正解のQuestionAnswerがis_correct: falseで保存される" do
          post quiz_results_path, params: mixed_params
          qa = QuizResult.last.question_answers.find_by(question: question2)
          expect(qa.is_correct).to be false
          expect(qa.choice).to eq(q2_wrong)
        end
      end

      context "未回答がある場合" do
        let(:incomplete_params) do
          {
            quiz_id: quiz.id,
            answers: { question1.id.to_s => q1_correct.id.to_s }
          }
        end

        it "QuizResultが作成されない" do
          expect { post quiz_results_path, params: incomplete_params }.not_to change(QuizResult, :count)
        end

        it "実施画面にリダイレクトされ警告が表示される" do
          post quiz_results_path, params: incomplete_params
          expect(response).to redirect_to(quiz_path(quiz))
          expect(flash[:alert]).to be_present
        end
      end

      context "再受験" do
        let(:retake_params) do
          {
            quiz_id: quiz.id,
            answers: {
              question1.id.to_s => q1_correct.id.to_s,
              question2.id.to_s => q2_correct.id.to_s
            }
          }
        end

        before do
          existing = create(:quiz_result, user: user, quiz: quiz, status: :completed, score: 50)
          create(:question_answer, quiz_result: existing, question: question1, choice: q1_wrong, is_correct: false)
          create(:question_answer, quiz_result: existing, question: question2, choice: q2_wrong, is_correct: false)
        end

        it "既存のQuizResultを上書きする（新規レコードは作られない）" do
          expect { post quiz_results_path, params: retake_params }.not_to change(QuizResult, :count)
        end

        it "スコアが新しい回答で更新される" do
          post quiz_results_path, params: retake_params
          expect(QuizResult.last.score).to eq(100)
        end

        it "既存のQuestionAnswerが新しい回答に入れ替わる" do
          post quiz_results_path, params: retake_params
          qa = QuizResult.last.question_answers.find_by(question: question1)
          expect(qa.choice).to eq(q1_correct)
          expect(qa.is_correct).to be true
        end
      end
    end
  end

  describe "GET /quiz_results/:id" do
    let(:quiz_result) { create(:quiz_result, user: user, quiz: quiz, status: :completed, score: 100, correct_count: 2, total_correct: 2) }

    before do
      create(:question_answer, quiz_result: quiz_result, question: question1, choice: q1_correct, is_correct: true)
      create(:question_answer, quiz_result: quiz_result, question: question2, choice: q2_correct, is_correct: true)
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get quiz_result_path(quiz_result)
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "自分の結果を閲覧する場合" do
      before { sign_in user }

      it "正常にレスポンスを返す" do
        get quiz_result_path(quiz_result)
        expect(response).to have_http_status(:ok)
      end

      it "スコアが表示される" do
        get quiz_result_path(quiz_result)
        expect(response.body).to include("100")
      end

      it "クイズタイトルが表示される" do
        get quiz_result_path(quiz_result)
        expect(response.body).to include("ルネサンスのテスト")
      end
    end

    context "他ユーザーの結果を閲覧する場合" do
      let(:other_user) { create(:user) }
      before { sign_in other_user }

      it "404を返す" do
        get quiz_result_path(quiz_result)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
