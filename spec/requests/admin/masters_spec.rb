require "rails_helper"

RSpec.describe "Admin::Masters", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }

  describe "認可" do
    context "未ログインの場合" do
      it "indexへのアクセスはログインページへリダイレクトされる" do
        get admin_masters_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { sign_in general_user }

      it "indexへのアクセスはroot_pathへリダイレクトされる" do
        get admin_masters_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("管理者権限が必要です")
      end
    end
  end

  describe "管理者でログインしている場合" do
    before { sign_in admin }

    describe "GET /admin/masters" do
      let!(:period)     { create(:period, name: "飛鳥時代") }
      let!(:region)     { create(:region, name: "近畿") }
      let!(:study_unit) { create(:study_unit, name: "古代日本の文化") }

      it "200を返すこと" do
        get admin_masters_path
        expect(response).to have_http_status(:ok)
      end

      it "3マスターの名前がすべて表示されること" do
        get admin_masters_path
        expect(response.body).to include("飛鳥時代")
        expect(response.body).to include("近畿")
        expect(response.body).to include("古代日本の文化")
      end
    end
  end
end
