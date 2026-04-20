require "rails_helper"

RSpec.describe "Admin::Quizzes", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }
  let(:category) { create(:quiz_category, name: "ルネサンス") }

  describe "認可" do
    context "未ログインの場合" do
      it "indexはログインページへリダイレクトされる" do
        get admin_quizzes_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "createはログインページへリダイレクトされる" do
        post admin_quizzes_path, params: { quiz: { title: "test", quiz_category_id: category.id } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { sign_in general_user }

      it "indexはroot_pathへリダイレクトされる" do
        get admin_quizzes_path
        expect(response).to redirect_to(root_path)
      end

      it "createは実行できずリダイレクトされる" do
        expect {
          post admin_quizzes_path, params: { quiz: { title: "test", quiz_category_id: category.id } }
        }.not_to change { Quiz.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "管理者でログインしている場合" do
    before { sign_in admin }

    describe "GET /admin/quizzes" do
      let!(:quiz1) { create(:quiz, title: "テストA", quiz_category: category) }
      let!(:other_category) { create(:quiz_category, name: "バロック") }
      let!(:quiz2) { create(:quiz, title: "テストB", quiz_category: other_category) }

      it "200を返し全quizを表示する" do
        get admin_quizzes_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("テストA")
        expect(response.body).to include("テストB")
      end

      it "quiz_category_idで絞り込みできる" do
        get admin_quizzes_path, params: { quiz_category_id: category.id }
        expect(response.body).to include("テストA")
        expect(response.body).not_to include("テストB")
      end
    end

    describe "GET /admin/quizzes/new" do
      it "200を返すこと" do
        get new_admin_quiz_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/quizzes" do
      context "正常系" do
        it "Quizが作成され詳細ページへリダイレクトすること" do
          expect {
            post admin_quizzes_path, params: { quiz: { title: "新テスト", quiz_category_id: category.id } }
          }.to change { Quiz.count }.by(1)
          expect(response).to redirect_to(admin_quiz_path(Quiz.last))
          expect(flash[:notice]).to include("新テスト")
        end
      end

      context "異常系" do
        it "titleが空なら作成されず422を返すこと" do
          expect {
            post admin_quizzes_path, params: { quiz: { title: "", quiz_category_id: category.id } }
          }.not_to change { Quiz.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET /admin/quizzes/:id" do
      let!(:quiz) { create(:quiz, title: "表示テスト", quiz_category: category) }

      it "200を返すこと" do
        get admin_quiz_path(quiz)
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("表示テスト")
      end
    end

    describe "GET /admin/quizzes/:id/edit" do
      let!(:quiz) { create(:quiz, quiz_category: category) }

      it "200を返すこと" do
        get edit_admin_quiz_path(quiz)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PATCH /admin/quizzes/:id" do
      let!(:quiz) { create(:quiz, title: "更新前", quiz_category: category) }

      context "正常系" do
        it "属性が更新され詳細ページへリダイレクトすること" do
          patch admin_quiz_path(quiz), params: { quiz: { title: "更新後", quiz_category_id: category.id } }
          expect(quiz.reload.title).to eq("更新後")
          expect(response).to redirect_to(admin_quiz_path(quiz))
        end
      end

      context "異常系" do
        it "titleが空なら更新されず422を返すこと" do
          patch admin_quiz_path(quiz), params: { quiz: { title: "", quiz_category_id: category.id } }
          expect(quiz.reload.title).to eq("更新前")
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH /admin/quizzes/:id/publish" do
      let(:quiz) { create(:quiz, quiz_category: category, published_at: nil) }

      context "問題が1問以上ある場合" do
        before { create(:question, quiz: quiz) }

        it "公開状態となり詳細ページへリダイレクトすること" do
          patch publish_admin_quiz_path(quiz)
          expect(quiz.reload.published?).to be true
          expect(response).to redirect_to(admin_quiz_path(quiz))
        end
      end

      context "問題が0問の場合" do
        it "公開されずアラートが出ること" do
          patch publish_admin_quiz_path(quiz)
          expect(quiz.reload.published?).to be false
          expect(response).to redirect_to(admin_quiz_path(quiz))
          expect(flash[:alert]).to be_present
        end
      end
    end

    describe "PATCH /admin/quizzes/:id/unpublish" do
      let(:quiz) do
        q = create(:quiz, quiz_category: category)
        create(:question, quiz: q)
        q.update!(published_at: 1.day.ago)
        q
      end

      it "非公開になること" do
        patch unpublish_admin_quiz_path(quiz)
        expect(quiz.reload.published?).to be false
        expect(response).to redirect_to(admin_quiz_path(quiz))
      end
    end

    describe "DELETE /admin/quizzes/:id" do
      let!(:quiz) { create(:quiz, quiz_category: category) }

      it "削除され一覧ページへリダイレクトすること" do
        expect {
          delete admin_quiz_path(quiz)
        }.to change { Quiz.count }.by(-1)
        expect(response).to redirect_to(admin_quizzes_path)
      end

      context "受験履歴(question_answers)が紐づいている場合" do
        it "FK違反せずに削除できること" do
          question = create(:question, quiz: quiz)
          choice = create(:choice, question: question, correct_answer: true)
          user = create(:user)
          quiz_result = create(:quiz_result, user: user, quiz: quiz)
          create(:question_answer, quiz_result: quiz_result, question: question, choice: choice)

          expect {
            delete admin_quiz_path(quiz)
          }.to change { Quiz.count }.by(-1)
            .and change { Question.count }.by(-1)
            .and change { Choice.count }.by(-1)
            .and change { QuizResult.count }.by(-1)
            .and change { QuestionAnswer.count }.by(-1)
        end
      end
    end
  end
end
