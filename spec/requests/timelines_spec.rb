require "rails_helper"

RSpec.describe "Timelines", type: :request do
  describe "GET /timelines/:id" do
    let!(:study_unit) { create(:study_unit, name: "ルネサンス") }

    context "正常系" do
      it "タイムラインページが表示される" do
        get timeline_path(study_unit)
        expect(response).to have_http_status(:ok)
      end

      it "学習単元名が表示される" do
        get timeline_path(study_unit)
        expect(response.body).to include("ルネサンス")
      end
    end

    context "eventsがある場合" do
      let!(:category) { create(:category, name: "芸術") }
      let!(:event1) { create(:event, title: "モナ・リザの制作", year: 1503, study_unit: study_unit, category: category) }
      let!(:event2) { create(:event, title: "最後の晩餐の制作", year: 1495, study_unit: study_unit, category: category) }

      it "eventsが年代順に表示される" do
        get timeline_path(study_unit)
        body = response.body
        expect(body).to include("モナ・リザの制作")
        expect(body).to include("最後の晩餐の制作")
        expect(body.index("最後の晩餐の制作")).to be < body.index("モナ・リザの制作")
      end

      it "カテゴリ名が表示される" do
        get timeline_path(study_unit)
        expect(response.body).to include("芸術")
      end

      it "年代が表示される" do
        get timeline_path(study_unit)
        expect(response.body).to include("1503")
        expect(response.body).to include("1495")
      end
    end

    context "関連する人物がいる場合" do
      let!(:event) { create(:event, title: "ルネサンスの始まり", study_unit: study_unit) }
      let!(:character) { create(:character, name: "ダ・ヴィンチ") }

      before do
        create(:event_character, event: event, character: character)
      end

      it "代表人物が表示される" do
        get timeline_path(study_unit)
        expect(response.body).to include("ダ・ヴィンチ")
      end
    end

    context "サイドバー" do
      let!(:other_unit) { create(:study_unit, name: "バロック") }

      it "全学習単元が表示される" do
        get timeline_path(study_unit)
        expect(response.body).to include("ルネサンス")
        expect(response.body).to include("バロック")
      end
    end

    context "存在しないIDの場合" do
      it "404エラーになる" do
        get timeline_path(id: 99999)
        expect(response).to have_http_status(:not_found)
      end
    end
  end
end
