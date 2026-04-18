require "rails_helper"

RSpec.describe "Admin::Events", type: :request do
  let(:admin) { create(:user, :admin) }
  let(:general_user) { create(:user) }

  let!(:period) { create(:period, name: "飛鳥時代") }
  let!(:region) { create(:region, name: "近畿") }
  let!(:category) { create(:category, name: "政治") }

  describe "認可" do
    context "未ログインの場合" do
      it "indexへのアクセスはログインページへリダイレクトされる" do
        get admin_events_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end

    context "一般ユーザーでログインしている場合" do
      before { sign_in general_user }

      it "indexへのアクセスはroot_pathへリダイレクトされる" do
        get admin_events_path
        expect(response).to redirect_to(root_path)
        expect(flash[:alert]).to eq("管理者権限が必要です")
      end

      it "destroyは実行できずリダイレクトされる" do
        event = create(:event)
        expect {
          delete admin_event_path(event)
        }.not_to change { Event.count }
        expect(response).to redirect_to(root_path)
      end
    end
  end

  describe "管理者でログインしている場合" do
    before { sign_in admin }

    describe "GET /admin/events" do
      let!(:event_a) { create(:event, title: "飛鳥の出来事", period: period, region: region, category: category) }
      let!(:event_b) do
        create(:event,
          title: "奈良の出来事",
          period: create(:period, name: "奈良時代"),
          region: create(:region, name: "関東"),
          category: create(:category, name: "文化"))
      end

      it "200を返すこと" do
        get admin_events_path
        expect(response).to have_http_status(:ok)
      end

      it "出来事のタイトルが表示されること" do
        get admin_events_path
        expect(response.body).to include("飛鳥の出来事")
        expect(response.body).to include("奈良の出来事")
      end

      context "period_idで絞り込む場合" do
        it "指定した時代のeventだけ表示されること" do
          get admin_events_path, params: { period_id: period.id }
          expect(response.body).to include("飛鳥の出来事")
          expect(response.body).not_to include("奈良の出来事")
        end
      end

      context "region_idで絞り込む場合" do
        it "指定した地域のeventだけ表示されること" do
          get admin_events_path, params: { region_id: region.id }
          expect(response.body).to include("飛鳥の出来事")
          expect(response.body).not_to include("奈良の出来事")
        end
      end

      context "category_idで絞り込む場合" do
        it "指定したカテゴリのeventだけ表示されること" do
          get admin_events_path, params: { category_id: category.id }
          expect(response.body).to include("飛鳥の出来事")
          expect(response.body).not_to include("奈良の出来事")
        end
      end
    end

    describe "DELETE /admin/events/:id" do
      let!(:event) { create(:event) }

      it "Eventが削除されリダイレクトすること" do
        expect {
          delete admin_event_path(event)
        }.to change { Event.count }.by(-1)
        expect(response).to redirect_to(admin_events_path)
      end
    end
  end
end
