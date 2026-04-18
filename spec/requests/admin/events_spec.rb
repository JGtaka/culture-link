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

    describe "GET /admin/events/new" do
      it "200を返すこと" do
        get new_admin_event_path
        expect(response).to have_http_status(:ok)
      end
    end

    describe "POST /admin/events" do
      let!(:study_unit) { create(:study_unit) }
      let(:valid_params) do
        {
          title: "大化の改新",
          year: 645,
          description: "中大兄皇子と中臣鎌足による政治改革",
          period_id: period.id,
          region_id: region.id,
          category_id: category.id,
          study_unit_id: study_unit.id
        }
      end

      context "正常系" do
        it "Eventが作成されリダイレクトすること" do
          expect {
            post admin_events_path, params: { event: valid_params }
          }.to change { Event.count }.by(1)
          expect(response).to redirect_to(admin_events_path)
          expect(flash[:notice]).to include("大化の改新")
        end

        it "選択した関連人物が紐付くこと" do
          character1 = create(:character, name: "中大兄皇子", period: period, study_unit: study_unit)
          character2 = create(:character, name: "中臣鎌足", period: period, study_unit: study_unit)
          post admin_events_path, params: {
            event: valid_params.merge(character_ids: [ character1.id, character2.id ])
          }
          expect(Event.last.characters).to contain_exactly(character1, character2)
        end

        it "存在しないcharacter_idが混入していても既存IDだけで紐付くこと" do
          character = create(:character, period: period, study_unit: study_unit)
          expect {
            post admin_events_path, params: {
              event: valid_params.merge(character_ids: [ character.id, 999_999 ])
            }
          }.to change { Event.count }.by(1)
          expect(Event.last.characters).to contain_exactly(character)
          expect(response).to redirect_to(admin_events_path)
        end
      end

      context "異常系" do
        it "titleが空ならEventは作成されず422を返すこと" do
          expect {
            post admin_events_path, params: { event: valid_params.merge(title: "") }
          }.not_to change { Event.count }
          expect(response).to have_http_status(:unprocessable_entity)
        end
      end
    end

    describe "GET /admin/events/:id/edit" do
      let!(:event) { create(:event) }

      it "200を返すこと" do
        get edit_admin_event_path(event)
        expect(response).to have_http_status(:ok)
      end
    end

    describe "PATCH /admin/events/:id" do
      let!(:event) { create(:event, title: "更新前") }
      let!(:study_unit) { create(:study_unit) }

      context "正常系" do
        it "属性が更新されリダイレクトすること" do
          patch admin_event_path(event), params: { event: { title: "更新後" } }
          expect(event.reload.title).to eq("更新後")
          expect(response).to redirect_to(admin_events_path)
        end

        it "関連人物を差し替えられること" do
          old_char = create(:character, name: "旧人物", period: period, study_unit: study_unit)
          new_char = create(:character, name: "新人物", period: period, study_unit: study_unit)
          create(:event_character, event: event, character: old_char)

          patch admin_event_path(event), params: {
            event: { character_ids: [ new_char.id ] }
          }
          expect(event.reload.characters).to contain_exactly(new_char)
        end

        it "関連人物を全て外せること" do
          character = create(:character, period: period, study_unit: study_unit)
          create(:event_character, event: event, character: character)

          patch admin_event_path(event), params: {
            event: { character_ids: [ "" ] }
          }
          expect(event.reload.characters).to be_empty
        end

        it "存在しないcharacter_idが混入していても既存IDだけで差し替えられること" do
          character = create(:character, period: period, study_unit: study_unit)
          patch admin_event_path(event), params: {
            event: { character_ids: [ character.id, 999_999 ] }
          }
          expect(event.reload.characters).to contain_exactly(character)
          expect(response).to redirect_to(admin_events_path)
        end
      end

      context "異常系" do
        it "titleが空なら更新されず422を返すこと" do
          patch admin_event_path(event), params: { event: { title: "" } }
          expect(event.reload.title).to eq("更新前")
          expect(response).to have_http_status(:unprocessable_entity)
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
