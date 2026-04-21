require "rails_helper"

RSpec.describe "Users::Sessions", type: :request do
  describe "POST /users/sign_in" do
    let(:password) { "password123" }

    context "通常ユーザー" do
      let!(:user) { create(:user, password: password) }

      it "ログインが成功する" do
        post user_session_path, params: { user: { email: user.email, password: password } }
        expect(response).to be_redirect
        follow_redirect!
        expect(response.body).not_to include("停止されています")
      end
    end

    context "停止中ユーザー" do
      let!(:user) { create(:user, password: password, suspended_at: 1.day.ago) }

      it "ログインできずサインインページへリダイレクトされること" do
        post user_session_path, params: { user: { email: user.email, password: password } }
        expect(response).to redirect_to(new_user_session_path)
        follow_redirect!
        expect(response.body).to include("停止されています")
      end

      it "セッションが作成されないこと" do
        post user_session_path, params: { user: { email: user.email, password: password } }
        get root_path
        expect(response.body).not_to include("ログアウト")
      end
    end
  end

  describe "ログイン中ユーザーの停止" do
    let(:user) { create(:user, password: "password123") }

    it "ログイン後に停止されたユーザーは次のリクエストでサインアウトされる" do
      sign_in user
      get profile_path
      expect(response).to have_http_status(:ok)

      user.update!(suspended_at: Time.current)

      get profile_path
      expect(response).to redirect_to(new_user_session_path)
    end
  end
end
