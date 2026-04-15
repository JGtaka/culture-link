require 'rails_helper'

RSpec.describe "StaticPages", type: :request do
  describe "GET /privacy" do
    it "プライバシーポリシーページが正常に表示される" do
      get privacy_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("プライバシーポリシー")
      expect(response.body).to include("culture-link")
      expect(response.body).to include("第1条")
      expect(response.body).to include("supportculturelink@gmail.com")
    end
  end

  describe "GET /terms" do
    it "利用規約ページが正常に表示される" do
      get terms_path
      expect(response).to have_http_status(:ok)
      expect(response.body).to include("利用規約")
      expect(response.body).to include("culture-link")
      expect(response.body).to include("第1条（適用）")
      expect(response.body).to include("第7条（利用規約の変更）")
    end
  end
end
