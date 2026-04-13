require "rails_helper"

RSpec.describe ArticleView, type: :model do
  describe "関連" do
    it "userに属する" do
      association = described_class.reflect_on_association(:user)
      expect(association.macro).to eq(:belongs_to)
    end

    it "articleにpolymorphicで属する" do
      association = described_class.reflect_on_association(:article)
      expect(association.macro).to eq(:belongs_to)
      expect(association.options[:polymorphic]).to be true
    end
  end

  describe "バリデーション" do
    let(:user) { create(:user) }
    let(:event) { create(:event) }

    it "user + article の組み合わせが一意であること" do
      create(:article_view, user: user, article: event)
      duplicate = build(:article_view, user: user, article: event)
      expect(duplicate).not_to be_valid
      expect(duplicate.errors[:user_id]).to include("はすでに存在します")
    end

    it "別ユーザーが同じ記事を閲覧するのは許される" do
      other_user = create(:user)
      create(:article_view, user: user, article: event)
      another = build(:article_view, user: other_user, article: event)
      expect(another).to be_valid
    end

    it "同じユーザーが別記事を閲覧するのは許される" do
      other_event = create(:event)
      create(:article_view, user: user, article: event)
      another = build(:article_view, user: user, article: other_event)
      expect(another).to be_valid
    end
  end

  describe "polymorphic対応" do
    let(:user) { create(:user) }

    it "Event を article として紐付けられる" do
      event = create(:event)
      view = create(:article_view, user: user, article: event)
      expect(view.article).to eq(event)
      expect(view.article_type).to eq("Event")
    end

    it "Character を article として紐付けられる" do
      character = create(:character)
      view = create(:article_view, user: user, article: character)
      expect(view.article).to eq(character)
      expect(view.article_type).to eq("Character")
    end
  end
end
