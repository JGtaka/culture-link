require "rails_helper"

RSpec.describe "Account::Passwords", type: :request do
  describe "PATCH /account/password" do
    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        patch account_password_path, params: { user: { current_password: "password123", password: "newpassword456", password_confirmation: "newpassword456" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "通常ユーザーでログイン中" do
      let(:user) { create(:user) }

      before { sign_in user }

      it "現在のパスワードが正しければパスワードを変更できる" do
        patch account_password_path, params: {
          user: {
            current_password: "password123",
            password: "newpassword456",
            password_confirmation: "newpassword456"
          }
        }
        expect(user.reload.valid_password?("newpassword456")).to be true
      end

      it "変更成功時はアカウント設定ページにリダイレクトされる" do
        patch account_password_path, params: {
          user: {
            current_password: "password123",
            password: "newpassword456",
            password_confirmation: "newpassword456"
          }
        }
        expect(response).to redirect_to(account_path)
      end

      it "現在のパスワードが間違っていれば変更されない" do
        patch account_password_path, params: {
          user: {
            current_password: "wrongpassword",
            password: "newpassword456",
            password_confirmation: "newpassword456"
          }
        }
        expect(user.reload.valid_password?("password123")).to be true
      end

      it "新しいパスワードと確認が一致しなければ変更されない" do
        patch account_password_path, params: {
          user: {
            current_password: "password123",
            password: "newpassword456",
            password_confirmation: "different789"
          }
        }
        expect(user.reload.valid_password?("password123")).to be true
      end

      it "新しいパスワードが短すぎる場合は変更されない" do
        patch account_password_path, params: {
          user: {
            current_password: "password123",
            password: "short",
            password_confirmation: "short"
          }
        }
        expect(user.reload.valid_password?("password123")).to be true
      end
    end

    context "Google連携ユーザーでログイン中" do
      let(:user) { create(:user, :google_user) }

      before { sign_in user }

      it "パスワード変更はできずアカウント設定ページにリダイレクトされる" do
        patch account_password_path, params: {
          user: {
            current_password: "anything",
            password: "newpassword456",
            password_confirmation: "newpassword456"
          }
        }
        expect(response).to redirect_to(account_path)
      end
    end
  end
end
