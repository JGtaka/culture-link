class CreateArticleViews < ActiveRecord::Migration[7.2]
  def change
    create_table :article_views do |t|
      t.references :user, null: false, foreign_key: true
      t.references :article, polymorphic: true, null: false, index: false
      t.timestamps
    end

    add_index :article_views, [ :article_type, :article_id ], name: "index_article_views_on_article"
    add_index :article_views, [ :user_id, :article_type, :article_id ], unique: true, name: "index_article_views_on_user_and_article"
    add_index :article_views, [ :user_id, :updated_at ]
  end
end
