require "rails_helper"

RSpec.describe Favorite, type: :model do
  describe "バリデーション" do
    it "ユーザーとお気に入り対象があれば有効" do
      favorite = build(:favorite)
      expect(favorite).to be_valid
    end

    it "同じユーザーが同じ記事を重複登録できない" do
      event = create(:event)
      user = create(:user)
      create(:favorite, user: user, favorable: event)
      duplicate = build(:favorite, user: user, favorable: event)
      expect(duplicate).not_to be_valid
    end

    it "異なるユーザーが同じ記事をお気に入りできる" do
      event = create(:event)
      create(:favorite, user: create(:user), favorable: event)
      favorite = build(:favorite, user: create(:user), favorable: event)
      expect(favorite).to be_valid
    end

    it "EventとCharacter両方をお気に入りできる" do
      user = create(:user)
      event_fav = create(:favorite, user: user, favorable: create(:event))
      char_fav = build(:favorite, user: user, favorable: create(:character))
      expect(event_fav).to be_valid
      expect(char_fav).to be_valid
    end
  end
end
