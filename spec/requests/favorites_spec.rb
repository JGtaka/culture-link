require "rails_helper"

RSpec.describe "Favorites", type: :request do
  let(:user) { create(:user) }
  let(:event) { create(:event) }
  let(:character) { create(:character) }

  describe "GET /favorites" do
    context "ログイン済みの場合" do
      before { sign_in user }

      it "お気に入り一覧が表示される" do
        get favorites_path
        expect(response).to have_http_status(:ok)
      end

      it "お気に入りした記事が表示される" do
        create(:favorite, user: user, favorable: event)
        get favorites_path
        expect(response.body).to include(event.title)
      end
    end

    context "未ログインの場合" do
      it "ログインページにリダイレクトされる" do
        get favorites_path
        expect(response).to redirect_to(new_user_session_path)
      end
    end
  end

  describe "POST /favorites" do
    before { sign_in user }

    it "Eventをお気に入りに追加できる" do
      expect {
        post favorites_path, params: { favorable_type: "Event", favorable_id: event.id }
      }.to change(Favorite, :count).by(1)
    end

    it "Characterをお気に入りに追加できる" do
      expect {
        post favorites_path, params: { favorable_type: "Character", favorable_id: character.id }
      }.to change(Favorite, :count).by(1)
    end

    it "同じ記事を重複登録できない" do
      create(:favorite, user: user, favorable: event)
      expect {
        post favorites_path, params: { favorable_type: "Event", favorable_id: event.id }
      }.not_to change(Favorite, :count)
    end
  end

  describe "DELETE /favorites/:id" do
    before { sign_in user }

    it "お気に入りを解除できる" do
      favorite = create(:favorite, user: user, favorable: event)
      expect {
        delete favorite_path(favorite)
      }.to change(Favorite, :count).by(-1)
    end
  end
end
