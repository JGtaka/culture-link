module ArticleViewable
  extend ActiveSupport::Concern

  private

  def record_article_view(article)
    return unless user_signed_in?

    view = current_user.article_views.find_or_initialize_by(article: article)
    # 閲覧履歴の記録失敗で画面表示を壊さないため save!ではなくsaveを使用
    view.new_record? ? view.save : view.touch
  end
end
