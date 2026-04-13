class ArticleView < ApplicationRecord
  belongs_to :user
  belongs_to :article, polymorphic: true

  validates :user_id, uniqueness: { scope: [ :article_type, :article_id ] }
end
