require "rails_helper"

RSpec.describe "Admin::Questions", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }
  let(:category) { create(:quiz_category) }
  let(:quiz) { create(:quiz, quiz_category: category) }

  def valid_params(body: "問題本文", correct_index: "0")
    {
      question: {
        body: body,
        correct_choice_index: correct_index,
        choices_attributes: {
          "0" => { body: "選択肢A" },
          "1" => { body: "選択肢B" },
          "2" => { body: "選択肢C" },
          "3" => { body: "選択肢D" }
        }
      }
    }
  end

  describe "認可" do
    context "未ログインの場合" do
      it "newはログインページへリダイレクトされる" do
        get new_admin_quiz_question_path(quiz)
        expect(response).to redirect_to(new_user_session_path)
      end

      it "createはログインページへリダイレクトされる" do
        post admin_quiz_questions_path(quiz), params: valid_params
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "一般ユーザーの場合" do
      before { sign_in general_user }

      it "createは実行できずリダイレクトされる" do
        expect {
          post admin_quiz_questions_path(quiz), params: valid_params
        }.not_to change { Question.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "管理者でログインしている場合" do
    before { sign_in admin }

    describe "GET /admin/quizzes/:quiz_id/questions/new" do
      it "200を返すこと" do
        get new_admin_quiz_question_path(quiz)
        expect(response).to have_http_status(:ok)
      end

      it "choicesが4つbuildされていること" do
        get new_admin_quiz_question_path(quiz)
        expect(response.body.scan(/question\[choices_attributes\]\[\d+\]\[body\]/).uniq.size).to eq(4)
      end
    end

    describe "POST /admin/quizzes/:quiz_id/questions" do
      context "正常系" do
        it "Questionと4つのChoiceが作成されること" do
          expect {
            post admin_quiz_questions_path(quiz), params: valid_params
          }.to change { Question.count }.by(1).and change { Choice.count }.by(4)
          question = Question.last
          expect(question.quiz).to eq(quiz)
          expect(question.choices.count).to eq(4)
          expect(question.choices.where(correct_answer: true).count).to eq(1)
          expect(question.choices.order(:id).first.correct_answer).to be true
        end

        it "詳細ページへリダイレクトすること" do
          post admin_quiz_questions_path(quiz), params: valid_params
          expect(response).to redirect_to(admin_quiz_path(quiz))
        end
      end

      context "異常系" do
        it "bodyが空なら作成されず422を返すこと" do
          expect {
            post admin_quiz_questions_path(quiz), params: valid_params(body: "")
          }.not_to change { Question.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "correct_choice_indexが空なら作成されないこと" do
          expect {
            post admin_quiz_questions_path(quiz), params: valid_params(correct_index: "")
          }.not_to change { Question.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "correct_choice_indexが範囲外なら作成されないこと" do
          expect {
            post admin_quiz_questions_path(quiz), params: valid_params(correct_index: "9")
          }.not_to change { Question.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET /admin/quizzes/:quiz_id/questions/:id/edit" do
      let!(:question) do
        q = create(:question, quiz: quiz)
        4.times { |i| q.choices.create!(body: "c#{i}", correct_answer: i.zero?) }
        q
      end

      it "200を返すこと" do
        get edit_admin_quiz_question_path(quiz, question)
        expect(response).to have_http_status(:ok)
      end

      context "別Quizの問題にアクセスした場合" do
        let(:other_quiz) { create(:quiz, quiz_category: category) }

        it "404を返すこと (権限漏れ防止)" do
          get edit_admin_quiz_question_path(other_quiz, question)
          expect(response).to have_http_status(:not_found)
        end
      end
    end

    describe "PATCH /admin/quizzes/:quiz_id/questions/:id" do
      let!(:question) do
        q = create(:question, quiz: quiz, body: "更新前")
        4.times { |i| q.choices.create!(body: "c#{i}", correct_answer: i.zero?) }
        q
      end

      context "正常系" do
        it "本文と正解位置が更新されること" do
          choices = question.choices.order(:id)
          patch admin_quiz_question_path(quiz, question), params: {
            question: {
              body: "更新後",
              correct_choice_index: "2",
              choices_attributes: {
                "0" => { id: choices[0].id, body: "A" },
                "1" => { id: choices[1].id, body: "B" },
                "2" => { id: choices[2].id, body: "C" },
                "3" => { id: choices[3].id, body: "D" }
              }
            }
          }
          expect(question.reload.body).to eq("更新後")
          expect(question.choices.order(:id).pluck(:correct_answer)).to eq([ false, false, true, false ])
          expect(response).to redirect_to(admin_quiz_path(quiz))
        end
      end
    end

    describe "DELETE /admin/quizzes/:quiz_id/questions/:id" do
      let!(:question) do
        q = create(:question, quiz: quiz)
        4.times { |i| q.choices.create!(body: "c#{i}", correct_answer: i.zero?) }
        q
      end

      it "Questionと紐づくChoiceが削除されること" do
        expect {
          delete admin_quiz_question_path(quiz, question)
        }.to change { Question.count }.by(-1).and change { Choice.count }.by(-4)
        expect(response).to redirect_to(admin_quiz_path(quiz))
      end

      context "受験履歴(question_answers)が紐づいている場合" do
        it "FK違反せずに削除できること" do
          user = create(:user)
          quiz_result = create(:quiz_result, user: user, quiz: quiz)
          create(:question_answer, quiz_result: quiz_result, question: question, choice: question.choices.first)

          expect {
            delete admin_quiz_question_path(quiz, question)
          }.to change { Question.count }.by(-1)
            .and change { Choice.count }.by(-4)
            .and change { QuestionAnswer.count }.by(-1)
        end
      end

      context "別Quizの問題を削除しようとした場合" do
        let(:other_quiz) { create(:quiz, quiz_category: category) }

        it "404を返し削除されないこと" do
          expect {
            delete admin_quiz_question_path(other_quiz, question)
          }.not_to change { Question.count }
          expect(response).to have_http_status(:not_found)
        end
      end
    end
  end
end
