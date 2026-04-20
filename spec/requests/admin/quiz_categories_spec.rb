require "rails_helper"

RSpec.describe "Admin::QuizCategories", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }

  describe "認可" do
    context "未ログインの場合" do
      it "indexはログインページへリダイレクトされる" do
        get admin_quiz_categories_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "createはログインページへリダイレクトされる" do
        post admin_quiz_categories_path, params: { quiz_category: { name: "test" } }
        expect(response).to redirect_to(new_user_session_path)
      end

      it "reorderはログインページへリダイレクトされる" do
        patch reorder_admin_quiz_categories_path, params: { ids: [] }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { sign_in general_user }

      it "indexはroot_pathへリダイレクトされる" do
        get admin_quiz_categories_path
        expect(response).to redirect_to(root_path)
      end

      it "createは実行できずリダイレクトされる" do
        expect {
          post admin_quiz_categories_path, params: { quiz_category: { name: "test" } }
        }.not_to change { QuizCategory.count }
        expect(response).to redirect_to(root_path)
      end

      it "reorderはroot_pathへリダイレクトされる" do
        category = create(:quiz_category, display_order: 1)
        original = category.display_order
        patch reorder_admin_quiz_categories_path, params: { ids: [ category.id ] }
        expect(response).to redirect_to(root_path)
        expect(category.reload.display_order).to eq(original)
      end
    end
  end

  describe "管理者でログインしている場合" do
    before { sign_in admin }

    describe "GET /admin/quiz_categories" do
      it "admin_masters_pathへリダイレクトすること" do
        get admin_quiz_categories_path
        expect(response).to redirect_to(admin_masters_path)
      end
    end

    describe "GET /admin/quiz_categories/new" do
      it "200を返すこと" do
        get new_admin_quiz_category_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/quiz_categories" do
      context "正常系" do
        it "QuizCategoryが作成されmastersページへリダイレクトすること" do
          expect {
            post admin_quiz_categories_path, params: { quiz_category: { name: "ルネサンス" } }
          }.to change { QuizCategory.count }.by(1)
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:notice]).to include("ルネサンス")
        end
      end

      context "異常系" do
        it "nameが空なら作成されず422を返すこと" do
          expect {
            post admin_quiz_categories_path, params: { quiz_category: { name: "" } }
          }.not_to change { QuizCategory.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "name重複なら作成されず422を返すこと" do
          create(:quiz_category, name: "ルネサンス")
          expect {
            post admin_quiz_categories_path, params: { quiz_category: { name: "ルネサンス" } }
          }.not_to change { QuizCategory.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET /admin/quiz_categories/:id/edit" do
      let!(:category) { create(:quiz_category) }

      it "200を返すこと" do
        get edit_admin_quiz_category_path(category)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PATCH /admin/quiz_categories/:id" do
      let!(:category) { create(:quiz_category, name: "更新前") }

      context "正常系" do
        it "属性が更新されmastersページへリダイレクトすること" do
          patch admin_quiz_category_path(category), params: { quiz_category: { name: "更新後" } }
          expect(category.reload.name).to eq("更新後")
          expect(response).to redirect_to(admin_masters_path)
        end
      end

      context "異常系" do
        it "nameが空なら更新されず422を返すこと" do
          patch admin_quiz_category_path(category), params: { quiz_category: { name: "" } }
          expect(category.reload.name).to eq("更新前")
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "PATCH /admin/quiz_categories/reorder" do
      let!(:c1) { create(:quiz_category, name: "A", display_order: 1) }
      let!(:c2) { create(:quiz_category, name: "B", display_order: 2) }
      let!(:c3) { create(:quiz_category, name: "C", display_order: 3) }

      it "指定した順に display_order が 1..N で採番されること" do
        patch reorder_admin_quiz_categories_path, params: { ids: [ c3.id, c1.id, c2.id ] }, as: :json
        expect(response).to have_http_status(:ok)
        expect(c3.reload.display_order).to eq(1)
        expect(c1.reload.display_order).to eq(2)
        expect(c2.reload.display_order).to eq(3)
      end

      it "空配列でも200を返すこと" do
        patch reorder_admin_quiz_categories_path, params: { ids: [] }, as: :json
        expect(response).to have_http_status(:ok)
      end
    end

    describe "DELETE /admin/quiz_categories/:id" do
      let!(:category) { create(:quiz_category) }

      context "関連Quizがない場合" do
        it "削除されmastersページへリダイレクトすること" do
          expect {
            delete admin_quiz_category_path(category)
          }.to change { QuizCategory.count }.by(-1)
          expect(response).to redirect_to(admin_masters_path)
        end
      end

      context "関連Quizがある場合" do
        it "削除されずアラートが出ること" do
          create(:quiz, quiz_category: category)
          expect {
            delete admin_quiz_category_path(category)
          }.not_to change { QuizCategory.count }
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
