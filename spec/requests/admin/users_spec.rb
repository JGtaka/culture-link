require "rails_helper"

RSpec.describe "Admin::Users", type: :request do
  let(:admin)        { create(:user, :admin) }
  let(:general_user) { create(:user) }

  describe "認可" do
    context "未ログインの場合" do
      it "indexはログインページへリダイレクトされる" do
        get admin_users_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { sign_in general_user }

      it "indexはroot_pathへリダイレクトされる" do
        get admin_users_path
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "管理者でログインしている場合" do
    before { sign_in admin }

    describe "GET /admin/users" do
      it "200を返すこと" do
        get admin_users_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "検索 (q)" do
      let!(:alice) { create(:user, name: "アリス", email: "alice@example.com") }
      let!(:bob)   { create(:user, name: "ボブ",   email: "bob@example.com") }

      it "名前部分一致で絞り込めること" do
        get admin_users_path, params: { q: "アリ" }
        expect(response.body).to include("アリス")
        expect(response.body).not_to include("ボブ</")
      end

      it "メール部分一致で絞り込めること" do
        get admin_users_path, params: { q: "bob@" }
        expect(response.body).to include("ボブ")
        expect(response.body).not_to include("アリス</")
      end
    end

    describe "ステータスフィルタ" do
      let!(:active_user)    { create(:user, name: "アクティブ太郎") }
      let!(:suspended_user) { create(:user, name: "停止花子", suspended_at: 1.day.ago) }

      it "status=activeで停止されていないユーザーのみ表示" do
        get admin_users_path, params: { status: "active" }
        expect(response.body).to include("アクティブ太郎")
        expect(response.body).not_to include("停止花子")
      end

      it "status=suspendedで停止ユーザーのみ表示" do
        get admin_users_path, params: { status: "suspended" }
        expect(response.body).to include("停止花子")
        expect(response.body).not_to include("アクティブ太郎")
      end

      it "status=allで全ユーザー表示" do
        get admin_users_path, params: { status: "all" }
        expect(response.body).to include("アクティブ太郎")
        expect(response.body).to include("停止花子")
      end
    end

    describe "登録期間フィルタ (from/to)" do
      let!(:old_user)    { create(:user, name: "古参ユーザー", created_at: 2.years.ago) }
      let!(:recent_user) { create(:user, name: "新人ユーザー", created_at: 3.days.ago) }

      it "指定した期間のユーザーのみ表示" do
        get admin_users_path, params: {
          from: 7.days.ago.to_date.iso8601,
          to: Date.current.iso8601
        }
        expect(response.body).to include("新人ユーザー")
        expect(response.body).not_to include("古参ユーザー")
      end
    end

    describe "統計カード" do
      before do
        create_list(:user, 3, created_at: Time.current.beginning_of_month + 1.day)
        create(:user, suspended_at: 1.day.ago)
        create(:user, current_sign_in_at: 5.days.ago)
        create(:user, current_sign_in_at: 40.days.ago)
      end

      it "data-testid経由で各統計値が表示されること" do
        get admin_users_path

        total     = User.count
        monthly   = User.where(created_at: Time.current.beginning_of_month..).count
        active    = User.recently_active.count
        suspended = User.suspended.count

        expect(response.body).to match(/data-testid="stat-total"[^>]*>\s*#{total}\s*</)
        expect(response.body).to match(/data-testid="stat-monthly"[^>]*>\s*\+?#{monthly}\s*</)
        expect(response.body).to match(/data-testid="stat-active"[^>]*>\s*#{active}\s*</)
        expect(response.body).to match(/data-testid="stat-suspended"[^>]*>\s*#{suspended}\s*</)
      end
    end

    describe "ページネーション" do
      before { create_list(:user, 25) }

      it "デフォルトで20件表示し、合計件数が出ること" do
        get admin_users_path
        expect(response.body).to include("data-testid=\"pagination-total\"")
        expect(response.body).to include((User.count).to_s)
      end
    end
  end
end
