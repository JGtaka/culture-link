require "rails_helper"

RSpec.describe "Profiles", type: :request do
  describe "GET /profile" do
    context "ログイン済みの場合" do
      let(:user) { create(:user, name: "テスト太郎") }

      before do
        sign_in user
      end

      it "プロフィールページが表示される" do
        get profile_path
        expect(response).to have_http_status(:ok)
      end

      it "ユーザー名が表示される" do
        get profile_path
        expect(response.body).to include("テスト太郎")
      end

      it "ウェルカムメッセージが表示される" do
        get profile_path
        expect(response.body).to include("おかえりなさい")
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get profile_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end
end
