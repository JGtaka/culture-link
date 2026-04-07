require "rails_helper"

RSpec.describe "Users::Registrations", type: :request do
  let(:user) { create(:user, name: "変更前", email: "before@example.com") }

  before do
    sign_in user
  end

  describe "GET /users/edit" do
    it "編集ページが表示される" do
      get edit_user_registration_path
      expect(response).to have_http_status(:ok)
    end

    it "現在の名前が表示される" do
      get edit_user_registration_path
      expect(response.body).to include("変更前")
    end

    it "パスワードフィールドが表示されない" do
      get edit_user_registration_path
      expect(response.body).not_to include("現在のパスワード")
      expect(response.body).not_to include("新しいパスワード")
    end
  end

  describe "PUT /users" do
    it "パスワードなしで名前を更新できる" do
      put user_registration_path, params: { user: { name: "変更後", email: user.email } }
      expect(user.reload.name).to eq("変更後")
    end

    it "パスワードなしでメールアドレスを更新できる" do
      put user_registration_path, params: { user: { name: user.name, email: "after@example.com" } }
      expect(user.reload.email).to eq("after@example.com")
    end

    it "更新後にプロフィールページへリダイレクトされる" do
      put user_registration_path, params: { user: { name: "変更後", email: user.email } }
      expect(response).to redirect_to(profile_path)
    end

    it "名前が空の場合は更新されない" do
      put user_registration_path, params: { user: { name: "", email: user.email } }
      expect(user.reload.name).to eq("変更前")
    end
  end
end
