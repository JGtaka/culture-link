require "rails_helper"

RSpec.describe "Accounts", type: :request do
  describe "GET /account" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get account_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "通常ユーザーでログイン中" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "正常に表示される" do
        get account_path
        expect(response).to have_http_status(:ok)
      end

      it "パスワード変更フォームが表示される" do
        get account_path
        expect(response.body).to include("パスワード変更")
        expect(response.body).to include("現在のパスワード")
      end

      it "退会ボタンが表示される" do
        get account_path
        expect(response.body).to include("退会する")
      end
    end

    context "Google連携ユーザーでログイン中" do
      let(:user) { create(:user, :google_user) }

      before { sign_in user }

      it "正常に表示される" do
        get account_path
        expect(response).to have_http_status(:ok)
      end

      it "パスワード変更フォームが表示されない" do
        get account_path
        expect(response.body).not_to include("現在のパスワード")
      end

      it "退会ボタンが表示される" do
        get account_path
        expect(response.body).to include("退会する")
      end
    end
  end
end
