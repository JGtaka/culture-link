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
  end
end
