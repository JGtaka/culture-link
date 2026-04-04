require "rails_helper"

RSpec.describe "Articles", type: :request do
  describe "GET /articles" do
    context "ページネーション" do
      before do
        # 合計8件作成（Event 4件 + Character 4件）
        create_list(:event, 4)
        create_list(:character, 4)
      end

      it "1ページ目に6件表示される" do
        get articles_path
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("8件")
      end

      it "1ページあたり最大6件に制限される" do
        get articles_path, params: { page: 1 }
        expect(response).to have_http_status(:ok)
      end

      it "2ページ目にアクセスできる" do
        get articles_path, params: { page: 2 }
        expect(response).to have_http_status(:ok)
      end

      it "ページネーションリンクが表示される" do
        get articles_path
        expect(response.body).to include("page=2")
      end
    end

    context "データが少ない場合" do
      before do
        create_list(:event, 3)
      end

      it "ページネーションリンクが表示されない" do
        get articles_path
        expect(response).to have_http_status(:ok)
        expect(response.body).not_to include("page=2")
      end
    end

    context "テキスト検索" do
      let!(:event_renaissance) { create(:event, title: "ルネサンス", description: "文化復興の時代") }
      let!(:event_baroque) { create(:event, title: "バロック音楽", description: "装飾的な音楽様式") }
      let!(:char_davinci) { create(:character, name: "ダ・ヴィンチ", description: "万能の天才", achievement: "モナ・リザを制作") }
      let!(:char_bach) { create(:character, name: "バッハ", description: "音楽の父", achievement: "マタイ受難曲を作曲") }

      it "Eventのtitleで検索できる" do
        get articles_path, params: { q: { keyword: "ルネサンス" } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("ルネサンス")
        expect(response.body).not_to include("バロック")
      end

      it "Characterのnameで検索できる" do
        get articles_path, params: { q: { keyword: "ヴィンチ" } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("ダ・ヴィンチ")
        expect(response.body).not_to include("バッハ")
      end

      it "Eventのdescriptionで検索できる" do
        get articles_path, params: { q: { keyword: "装飾的" } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("バロック")
      end

      it "Characterのachievementで検索できる" do
        get articles_path, params: { q: { keyword: "モナ・リザ" } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("ダ・ヴィンチ")
      end

      it "検索キーワードが空の場合は全件表示される" do
        get articles_path, params: { q: { keyword: "" } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("4件")
      end

      it "該当なしの場合は0件になる" do
        get articles_path, params: { q: { keyword: "存在しないキーワード" } }
        expect(response).to have_http_status(:ok)
        expect(response.body).to include("0件")
      end
    end
  end
end
