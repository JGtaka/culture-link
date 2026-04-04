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

    context "時代フィルター" do
      let!(:period_ancient) { create(:period, name: "古代テスト") }
      let!(:period_medieval) { create(:period, name: "中世テスト") }
      let!(:event_ancient) { create(:event, title: "古代出来事AAA", period: period_ancient) }
      let!(:event_medieval) { create(:event, title: "中世出来事BBB", period: period_medieval) }
      let!(:char_ancient) { create(:character, name: "古代人物CCC", period: period_ancient) }
      let!(:char_medieval) { create(:character, name: "中世人物DDD", period: period_medieval) }

      it "時代で絞り込みできる" do
        get articles_path, params: { period_ids: [ period_ancient.id ] }
        expect(response.body).to include("古代出来事AAA")
        expect(response.body).to include("古代人物CCC")
        expect(response.body).not_to include("中世出来事BBB")
        expect(response.body).not_to include("中世人物DDD")
      end

      it "複数の時代で絞り込みできる" do
        get articles_path, params: { period_ids: [ period_ancient.id, period_medieval.id ] }
        expect(response.body).to include("古代出来事AAA")
        expect(response.body).to include("中世出来事BBB")
        expect(response.body).to include("古代人物CCC")
        expect(response.body).to include("中世人物DDD")
      end
    end

    context "学習単元フィルター" do
      let!(:unit_renaissance) { create(:study_unit, name: "ルネサンス") }
      let!(:unit_baroque) { create(:study_unit, name: "バロック") }
      let!(:event_renaissance) { create(:event, title: "モナ・リザ制作", study_unit: unit_renaissance) }
      let!(:event_baroque) { create(:event, title: "バロック音楽", study_unit: unit_baroque) }
      let!(:char_renaissance) { create(:character, name: "ダ・ヴィンチ", study_unit: unit_renaissance) }
      let!(:char_baroque) { create(:character, name: "バッハ", study_unit: unit_baroque) }

      it "学習単元で絞り込みできる" do
        get articles_path, params: { study_unit_id: unit_renaissance.id }
        expect(response.body).to include("モナ・リザ制作")
        expect(response.body).to include("ダ・ヴィンチ")
        expect(response.body).not_to include("バロック音楽")
        expect(response.body).not_to include("バッハ")
      end
    end

    context "地域フィルター" do
      let!(:region_europe) { create(:region, name: "ヨーロッパ") }
      let!(:region_east_asia) { create(:region, name: "東アジア") }
      let!(:event_europe) { create(:event, title: "ルネサンス", region: region_europe) }
      let!(:event_asia) { create(:event, title: "水墨画", region: region_east_asia) }
      let!(:char_europe) { create(:character, name: "ダ・ヴィンチ", region: region_europe) }
      let!(:char_asia) { create(:character, name: "雪舟", region: region_east_asia) }

      it "地域で絞り込みできる" do
        get articles_path, params: { region_id: region_europe.id }
        expect(response.body).to include("ルネサンス")
        expect(response.body).to include("ダ・ヴィンチ")
        expect(response.body).not_to include("水墨画")
        expect(response.body).not_to include("雪舟")
      end
    end

    context "フィルターの組み合わせ" do
      let!(:period_medieval) { create(:period, name: "中世") }
      let!(:region_europe) { create(:region, name: "ヨーロッパ") }
      let!(:region_east_asia) { create(:region, name: "東アジア") }
      let!(:event_match) { create(:event, title: "ルネサンス", period: period_medieval, region: region_europe) }
      let!(:event_no_match) { create(:event, title: "水墨画", period: period_medieval, region: region_east_asia) }

      it "時代と地域を組み合わせて絞り込みできる" do
        get articles_path, params: { period_ids: [ period_medieval.id ], region_id: region_europe.id }
        expect(response.body).to include("ルネサンス")
        expect(response.body).not_to include("水墨画")
      end
    end
  end
end
