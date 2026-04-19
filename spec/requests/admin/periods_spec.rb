require "rails_helper"

RSpec.describe "Admin::Periods", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }

  describe "認可" do
    context "未ログインの場合" do
      it "indexはログインページへリダイレクトされる" do
        get admin_periods_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "createはログインページへリダイレクトされる" do
        post admin_periods_path, params: { period: { name: "test" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { sign_in general_user }

      it "indexはroot_pathへリダイレクトされる" do
        get admin_periods_path
        expect(response).to redirect_to(root_path)
      end

      it "createは実行できずリダイレクトされる" do
        expect {
          post admin_periods_path, params: { period: { name: "test" } }
        }.not_to change { Period.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "管理者でログインしている場合" do
    before { sign_in admin }

    describe "GET /admin/periods" do
      it "admin_masters_pathへリダイレクトすること" do
        get admin_periods_path
        expect(response).to redirect_to(admin_masters_path)
      end
    end

    describe "GET /admin/periods/new" do
      it "200を返すこと (Turbo Frameレスポンス)" do
        get new_admin_period_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/periods" do
      context "正常系" do
        it "Periodが作成されmastersページへリダイレクトすること" do
          expect {
            post admin_periods_path, params: { period: { name: "縄文時代" } }
          }.to change { Period.count }.by(1)
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:notice]).to include("縄文時代")
        end
      end

      context "異常系" do
        it "nameが空ならPeriodは作成されず422を返すこと" do
          expect {
            post admin_periods_path, params: { period: { name: "" } }
          }.not_to change { Period.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "name重複なら作成されず422を返すこと" do
          create(:period, name: "縄文時代")
          expect {
            post admin_periods_path, params: { period: { name: "縄文時代" } }
          }.not_to change { Period.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET /admin/periods/:id/edit" do
      let!(:period) { create(:period) }

      it "200を返すこと" do
        get edit_admin_period_path(period)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PATCH /admin/periods/:id" do
      let!(:period) { create(:period, name: "更新前") }

      context "正常系" do
        it "属性が更新されmastersページへリダイレクトすること" do
          patch admin_period_path(period), params: { period: { name: "更新後" } }
          expect(period.reload.name).to eq("更新後")
          expect(response).to redirect_to(admin_masters_path)
        end
      end

      context "異常系" do
        it "nameが空なら更新されず422を返すこと" do
          patch admin_period_path(period), params: { period: { name: "" } }
          expect(period.reload.name).to eq("更新前")
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE /admin/periods/:id" do
      let!(:period) { create(:period) }

      context "関連レコードが無い場合" do
        it "削除されmastersページへリダイレクトすること" do
          expect {
            delete admin_period_path(period)
          }.to change { Period.count }.by(-1)
          expect(response).to redirect_to(admin_masters_path)
        end
      end

      context "関連レコードがある場合" do
        let!(:study_unit) { create(:study_unit) }
        let!(:region)     { create(:region) }
        let!(:category)   { create(:category) }

        it "関連eventがあれば削除されずアラートが出ること" do
          create(:event, period: period, region: region, category: category, study_unit: study_unit)
          expect {
            delete admin_period_path(period)
          }.not_to change { Period.count }
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:alert]).to be_present
        end

        it "関連characterがあれば削除されずアラートが出ること" do
          create(:character, period: period, study_unit: study_unit)
          expect {
            delete admin_period_path(period)
          }.not_to change { Period.count }
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
