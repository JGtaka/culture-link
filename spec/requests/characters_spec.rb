require "rails_helper"

RSpec.describe "Characters", type: :request do
  describe "GET /characters/:id" do
    let!(:character) do
      create(:character,
        name: "レオナルド・ダ・ヴィンチ",
        description: "ルネサンスの万能の天才",
        achievement: "絵画、科学、工学を融合した知の巨人",
        year: 1452
      )
    end

    context "正常系" do
      it "詳細ページが表示される" do
        get character_path(character)
        expect(response).to have_http_status(:ok)
      end

      it "人物の基本情報が表示される" do
        get character_path(character)
        expect(response.body).to include("レオナルド・ダ・ヴィンチ")
        expect(response.body).to include("ルネサンスの万能の天才")
        expect(response.body).to include("絵画、科学、工学を融合した知の巨人")
        expect(response.body).to include("1452")
      end

      it "時代・地域の情報が表示される" do
        get character_path(character)
        expect(response.body).to include(character.period.name)
        expect(response.body).to include(character.region.name)
      end
    end

    context "関連する出来事がある場合" do
      let!(:event1) { create(:event, title: "モナ・リザの制作", year: 1503) }
      let!(:event2) { create(:event, title: "最後の晩餐の制作", year: 1495) }

      before do
        create(:event_character, event: event1, character: character)
        create(:event_character, event: event2, character: character)
      end

      it "関連する出来事が表示される" do
        get character_path(character)
        expect(response.body).to include("モナ・リザの制作")
        expect(response.body).to include("最後の晩餐の制作")
      end
    end

    context "関連する出来事がない場合" do
      it "エラーにならず表示される" do
        get character_path(character)
        expect(response).to have_http_status(:ok)
      end
    end

    context "存在しないIDの場合" do
      it "404エラーになる" do
        get character_path(id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end

    context "閲覧履歴の記録" do
      let(:user) { create(:user) }

      context "ログイン中の場合" do
        before { sign_in user }

        it "閲覧するとarticle_viewが記録される" do
          expect {
            get character_path(character)
          }.to change { ArticleView.count }.by(1)
          view = ArticleView.last
          expect(view.user).to eq(user)
          expect(view.article).to eq(character)
        end

        it "同じ人物を複数回閲覧してもレコードは1件のまま" do
          get character_path(character)
          expect {
            get character_path(character)
          }.not_to change { ArticleView.count }
        end

        it "再閲覧時にupdated_atが更新される" do
          get character_path(character)
          first_updated_at = ArticleView.last.updated_at
          travel_to 1.hour.from_now do
            get character_path(character)
          end
          expect(ArticleView.last.updated_at).to be > first_updated_at
        end
      end

      context "未ログインの場合" do
        it "article_viewは記録されない" do
          expect {
            get character_path(character)
          }.not_to change { ArticleView.count }
        end
      end

      context "Turboのprefetchリクエストの場合" do
        let(:user) { create(:user) }
        before { sign_in user }

        it "X-Sec-Purpose: prefetch が付いていると記録されない" do
          expect {
            get character_path(character), headers: { "X-Sec-Purpose" => "prefetch" }
          }.not_to change { ArticleView.count }
        end

        it "Sec-Purpose: prefetch が付いていると記録されない" do
          expect {
            get character_path(character), headers: { "Sec-Purpose" => "prefetch" }
          }.not_to change { ArticleView.count }
        end

        it "Purpose: prefetch が付いていると記録されない" do
          expect {
            get character_path(character), headers: { "Purpose" => "prefetch" }
          }.not_to change { ArticleView.count }
        end
      end
    end
  end
end
