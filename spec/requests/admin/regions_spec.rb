require "rails_helper"

RSpec.describe "Admin::Regions", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }

  describe "認可" do
    context "未ログインの場合" do
      it "createはログインページへリダイレクトされる" do
        post admin_regions_path, params: { region: { name: "test" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { sign_in general_user }

      it "createは実行できずリダイレクトされる" do
        expect {
          post admin_regions_path, params: { region: { name: "test" } }
        }.not_to change { Region.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "管理者でログインしている場合" do
    before { sign_in admin }

    describe "GET /admin/regions/new" do
      it "200を返すこと" do
        get new_admin_region_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/regions" do
      context "正常系" do
        it "Regionが作成されmastersページへリダイレクトすること" do
          expect {
            post admin_regions_path, params: { region: { name: "近畿" } }
          }.to change { Region.count }.by(1)
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:notice]).to include("近畿")
        end
      end

      context "異常系" do
        it "nameが空ならRegionは作成されず422を返すこと" do
          expect {
            post admin_regions_path, params: { region: { name: "" } }
          }.not_to change { Region.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "name重複なら作成されず422を返すこと" do
          create(:region, name: "近畿")
          expect {
            post admin_regions_path, params: { region: { name: "近畿" } }
          }.not_to change { Region.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET /admin/regions/:id/edit" do
      let!(:region) { create(:region) }

      it "200を返すこと" do
        get edit_admin_region_path(region)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PATCH /admin/regions/:id" do
      let!(:region) { create(:region, name: "更新前") }

      context "正常系" do
        it "属性が更新されmastersページへリダイレクトすること" do
          patch admin_region_path(region), params: { region: { name: "更新後" } }
          expect(region.reload.name).to eq("更新後")
          expect(response).to redirect_to(admin_masters_path)
        end
      end

      context "異常系" do
        it "nameが空なら更新されず422を返すこと" do
          patch admin_region_path(region), params: { region: { name: "" } }
          expect(region.reload.name).to eq("更新前")
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE /admin/regions/:id" do
      let!(:region) { create(:region) }

      context "関連レコードが無い場合" do
        it "削除されmastersページへリダイレクトすること" do
          expect {
            delete admin_region_path(region)
          }.to change { Region.count }.by(-1)
          expect(response).to redirect_to(admin_masters_path)
        end
      end

      context "関連レコードがある場合" do
        let!(:study_unit) { create(:study_unit) }
        let!(:period)     { create(:period) }
        let!(:category)   { create(:category) }

        it "関連eventがあれば削除されずアラートが出ること" do
          create(:event, period: period, region: region, category: category, study_unit: study_unit)
          expect {
            delete admin_region_path(region)
          }.not_to change { Region.count }
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:alert]).to be_present
        end

        it "関連characterがあれば削除されずアラートが出ること" do
          create(:character, period: period, study_unit: study_unit, region: region)
          expect {
            delete admin_region_path(region)
          }.not_to change { Region.count }
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
