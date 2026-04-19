require "rails_helper"

RSpec.describe "Admin::StudyUnits", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }

  describe "認可" do
    context "未ログインの場合" do
      it "indexはログインページへリダイレクトされる" do
        get admin_study_units_path
        expect(response).to redirect_to(new_user_session_path)
      end

      it "createはログインページへリダイレクトされる" do
        post admin_study_units_path, params: { study_unit: { name: "test" } }
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { sign_in general_user }

      it "indexはroot_pathへリダイレクトされる" do
        get admin_study_units_path
        expect(response).to redirect_to(root_path)
      end

      it "createは実行できずリダイレクトされる" do
        expect {
          post admin_study_units_path, params: { study_unit: { name: "test" } }
        }.not_to change { StudyUnit.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "管理者でログインしている場合" do
    before { sign_in admin }

    describe "GET /admin/study_units" do
      it "admin_masters_pathへリダイレクトすること" do
        get admin_study_units_path
        expect(response).to redirect_to(admin_masters_path)
      end
    end

    describe "GET /admin/study_units/new" do
      it "200を返すこと" do
        get new_admin_study_unit_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/study_units" do
      context "正常系" do
        it "StudyUnitが作成されmastersページへリダイレクトすること" do
          expect {
            post admin_study_units_path, params: { study_unit: { name: "古代日本の文化" } }
          }.to change { StudyUnit.count }.by(1)
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:notice]).to include("古代日本の文化")
        end
      end

      context "異常系" do
        it "nameが空ならStudyUnitは作成されず422を返すこと" do
          expect {
            post admin_study_units_path, params: { study_unit: { name: "" } }
          }.not_to change { StudyUnit.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end

        it "name重複なら作成されず422を返すこと" do
          create(:study_unit, name: "古代日本の文化")
          expect {
            post admin_study_units_path, params: { study_unit: { name: "古代日本の文化" } }
          }.not_to change { StudyUnit.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET /admin/study_units/:id/edit" do
      let!(:study_unit) { create(:study_unit) }

      it "200を返すこと" do
        get edit_admin_study_unit_path(study_unit)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PATCH /admin/study_units/:id" do
      let!(:study_unit) { create(:study_unit, name: "更新前") }

      context "正常系" do
        it "属性が更新されmastersページへリダイレクトすること" do
          patch admin_study_unit_path(study_unit), params: { study_unit: { name: "更新後" } }
          expect(study_unit.reload.name).to eq("更新後")
          expect(response).to redirect_to(admin_masters_path)
        end
      end

      context "異常系" do
        it "nameが空なら更新されず422を返すこと" do
          patch admin_study_unit_path(study_unit), params: { study_unit: { name: "" } }
          expect(study_unit.reload.name).to eq("更新前")
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "DELETE /admin/study_units/:id" do
      let!(:study_unit) { create(:study_unit) }

      context "関連レコードが無い場合" do
        it "削除されmastersページへリダイレクトすること" do
          expect {
            delete admin_study_unit_path(study_unit)
          }.to change { StudyUnit.count }.by(-1)
          expect(response).to redirect_to(admin_masters_path)
        end
      end

      context "関連レコードがある場合" do
        let!(:period)   { create(:period) }
        let!(:region)   { create(:region) }
        let!(:category) { create(:category) }

        it "関連eventがあれば削除されずアラートが出ること" do
          create(:event, period: period, region: region, category: category, study_unit: study_unit)
          expect {
            delete admin_study_unit_path(study_unit)
          }.not_to change { StudyUnit.count }
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:alert]).to be_present
        end

        it "関連characterがあれば削除されずアラートが出ること" do
          create(:character, study_unit: study_unit, period: period, region: region)
          expect {
            delete admin_study_unit_path(study_unit)
          }.not_to change { StudyUnit.count }
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:alert]).to be_present
        end

        it "ユーザーのscheduleに紐付いていれば削除されずアラートが出ること" do
          create(:study_unit_schedule, study_unit: study_unit)
          expect {
            delete admin_study_unit_path(study_unit)
          }.not_to change { StudyUnit.count }
          expect(response).to redirect_to(admin_masters_path)
          expect(flash[:alert]).to be_present
        end
      end
    end
  end
end
