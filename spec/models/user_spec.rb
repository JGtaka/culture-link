require 'rails_helper'

RSpec.describe User, type: :model do
  describe "バリデーション" do
    it "名前、メールアドレス、パスワードがあれば有効" do
      user = build(:user)
      expect(user).to be_valid
    end

    it "名前がなければ無効" do
      user = build(:user, name: "")
      expect(user).not_to be_valid
      expect(user.errors[:name]).to include("を入力してください")
    end

    it "メールアドレスがなければ無効" do
      user = build(:user, email: "")
      expect(user).not_to be_valid
    end

    it "パスワードがなければ無効" do
      user = build(:user, password: "")
      expect(user).not_to be_valid
    end

    it "メールアドレスが重複していれば無効" do
      create(:user, email: "duplicate@example.com")
      user = build(:user, email: "duplicate@example.com")
      expect(user).not_to be_valid
    end

    it "パスワードが6文字未満なら無効" do
      user = build(:user, password: "12345", password_confirmation: "12345")
      expect(user).not_to be_valid
    end
  end
end
