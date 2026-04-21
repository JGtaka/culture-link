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

  describe ".from_omniauth" do
    let(:auth) do
      OmniAuth::AuthHash.new(
        provider: "google_oauth2",
        uid: "123456789",
        info: {
          email: "new_user@example.com",
          name: "新規ユーザー",
          email_verified: true
        }
      )
    end

    context "email_verifiedがtrueの場合" do
      context "provider/uidが一致するユーザーが存在しないとき" do
        it "新しいユーザーを作成する" do
          expect { User.from_omniauth(auth) }.to change(User, :count).by(1)
        end

        it "作成したユーザーのprovider/uid/email/nameが設定される" do
          user = User.from_omniauth(auth)
          expect(user).to be_persisted
          expect(user.provider).to eq("google_oauth2")
          expect(user.uid).to eq("123456789")
          expect(user.email).to eq("new_user@example.com")
          expect(user.name).to eq("新規ユーザー")
        end
      end

      context "provider/uidが一致するユーザーが既に存在するとき" do
        it "既存ユーザーを返し、新規作成しない" do
          existing = User.from_omniauth(auth)
          expect { User.from_omniauth(auth) }.not_to change(User, :count)
          expect(User.from_omniauth(auth)).to eq(existing)
        end
      end

      context "同じメールアドレスの既存Deviseユーザーが存在するとき" do
        before { create(:user, email: "new_user@example.com") }

        it "新規作成せず、既存ユーザーにも紐付けず、nilを返す" do
          expect { @result = User.from_omniauth(auth) }.not_to change(User, :count)
          expect(@result).to be_nil
        end
      end
    end

    context "email_verifiedがfalseの場合" do
      before { auth.info.email_verified = false }

      it "ユーザーを作成せずnilを返す" do
        expect { @result = User.from_omniauth(auth) }.not_to change(User, :count)
        expect(@result).to be_nil
      end
    end
  end

  describe "#password_changeable?" do
    it "通常ユーザーはtrueを返す" do
      user = build(:user)
      expect(user.password_changeable?).to be true
    end

    it "OAuth連携ユーザーはfalseを返す" do
      user = build(:user, :google_user)
      expect(user.password_changeable?).to be false
    end
  end

  describe "#password_required?" do
    context "OAuth経由のユーザー(providerあり)の場合" do
      it "パスワードなしでも保存できる" do
        user = User.new(
          name: "OAuthユーザー",
          email: "oauth@example.com",
          provider: "google_oauth2",
          uid: "999"
        )
        expect(user.save).to be true
      end
    end

    context "通常のユーザー(providerなし)の場合" do
      it "パスワードが必須" do
        user = User.new(name: "通常", email: "normal@example.com")
        expect(user).not_to be_valid
        expect(user.errors[:password]).to be_present
      end
    end
  end

  describe "#suspended?" do
    it "suspended_atがnilならfalseを返す" do
      user = build(:user, suspended_at: nil)
      expect(user.suspended?).to be false
    end

    it "suspended_atが設定されていればtrueを返す" do
      user = build(:user, suspended_at: Time.current)
      expect(user.suspended?).to be true
    end
  end

  describe "スコープ" do
    let!(:active_user)    { create(:user, suspended_at: nil) }
    let!(:suspended_user) { create(:user, suspended_at: 1.day.ago) }

    describe ".active_users" do
      it "停止されていないユーザーのみを返す" do
        expect(User.active_users).to include(active_user)
        expect(User.active_users).not_to include(suspended_user)
      end
    end

    describe ".suspended" do
      it "停止されているユーザーのみを返す" do
        expect(User.suspended).to include(suspended_user)
        expect(User.suspended).not_to include(active_user)
      end
    end

    describe ".recently_active" do
      let!(:recent_user)  { create(:user, current_sign_in_at: 5.days.ago) }
      let!(:stale_user)   { create(:user, current_sign_in_at: 40.days.ago) }
      let!(:no_login_user) { create(:user, current_sign_in_at: nil) }

      it "30日以内にログインしたユーザーのみを返す" do
        expect(User.recently_active).to include(recent_user)
        expect(User.recently_active).not_to include(stale_user, no_login_user)
      end
    end
  end

  describe "#update_tracked_fields" do
    let(:user) { create(:user) }
    let(:request) { instance_double("ActionDispatch::Request", remote_ip: "127.0.0.1") }

    it "current_sign_in_at / last_sign_in_at / sign_in_countを更新する" do
      freeze_time do
        user.update_tracked_fields(request)
        expect(user.current_sign_in_at).to eq(Time.current)
        expect(user.last_sign_in_at).to eq(Time.current)
        expect(user.sign_in_count).to eq(1)
      end
    end

    it "2回目のログインでlast_sign_in_atが前回のcurrentに移る" do
      first_time = 2.days.ago
      user.update!(current_sign_in_at: first_time, sign_in_count: 1)

      user.update_tracked_fields(request)
      expect(user.last_sign_in_at).to be_within(1.second).of(first_time)
      expect(user.sign_in_count).to eq(2)
    end

    it "IPアドレス関連カラムに値を書き込まない (IPは取得しない)" do
      expect(user).not_to respond_to(:current_sign_in_ip=)
      expect(user).not_to respond_to(:last_sign_in_ip=)
    end
  end
end
