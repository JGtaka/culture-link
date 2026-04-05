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
  end
end
