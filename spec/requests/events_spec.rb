require "rails_helper"

RSpec.describe "Events", type: :request do
  describe "GET /events/:id" do
    let!(:event) do
      create(:event,
        title: "イタリア・ルネサンス",
        description: "中世から近代への移行期を象徴するヨーロッパの歴史的時代",
        year: 1400
      )
    end

    context "正常系" do
      it "詳細ページが表示される" do
        get event_path(event)
        expect(response).to have_http_status(:ok)
      end

      it "出来事の基本情報が表示される" do
        get event_path(event)
        expect(response.body).to include("イタリア・ルネサンス")
        expect(response.body).to include("中世から近代への移行期を象徴するヨーロッパの歴史的時代")
        expect(response.body).to include("1400")
      end

      it "時代・カテゴリ・地域の情報が表示される" do
        get event_path(event)
        expect(response.body).to include(event.period.name)
        expect(response.body).to include(event.category.name)
        expect(response.body).to include(event.region.name)
      end
    end

    context "関連する人物がいる場合" do
      let!(:char1) { create(:character, name: "ダ・ヴィンチ") }
      let!(:char2) { create(:character, name: "ミケランジェロ") }

      before do
        create(:event_character, event: event, character: char1)
        create(:event_character, event: event, character: char2)
      end

      it "関連する人物が表示される" do
        get event_path(event)
        expect(response.body).to include("ダ・ヴィンチ")
        expect(response.body).to include("ミケランジェロ")
      end
    end

    context "関連する人物がいない場合" do
      it "エラーにならず表示される" do
        get event_path(event)
        expect(response).to have_http_status(:ok)
      end
    end

    context "存在しないIDの場合" do
      it "404エラーになる" do
        get event_path(id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "閲覧履歴の記録" do
      let(:user) { create(:user) }

      context "ログイン中の場合" do
        before { sign_in user }

        it "閲覧するとarticle_viewが記録される" do
          expect {
            get event_path(event)
          }.to change { ArticleView.count }.by(1)
          view = ArticleView.last
          expect(view.user).to eq(user)
          expect(view.article).to eq(event)
        end

        it "同じ記事を複数回閲覧してもレコードは1件のまま" do
          get event_path(event)
          expect {
            get event_path(event)
          }.not_to change { ArticleView.count }
        end

        it "再閲覧時にupdated_atが更新される" do
          get event_path(event)
          first_updated_at = ArticleView.last.updated_at
          travel_to 1.hour.from_now do
            get event_path(event)
          end
          expect(ArticleView.last.updated_at).to be > first_updated_at
        end
      end

      context "未ログインの場合" do
        it "article_viewは記録されない" do
          expect {
            get event_path(event)
          }.not_to change { ArticleView.count }
        end
      end

      context "Turboのprefetchリクエストの場合" do
        let(:user) { create(:user) }
        before { sign_in user }

        it "X-Sec-Purpose: prefetch が付いていると記録されない" do
          expect {
            get event_path(event), headers: { "X-Sec-Purpose" => "prefetch" }
          }.not_to change { ArticleView.count }
        end

        it "Sec-Purpose: prefetch が付いていると記録されない" do
          expect {
            get event_path(event), headers: { "Sec-Purpose" => "prefetch" }
          }.not_to change { ArticleView.count }
        end

        it "Purpose: prefetch が付いていると記録されない" do
          expect {
            get event_path(event), headers: { "Purpose" => "prefetch" }
          }.not_to change { ArticleView.count }
        end
      end
    end
  end
end
