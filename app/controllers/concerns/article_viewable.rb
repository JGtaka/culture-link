module ArticleViewable
  extend ActiveSupport::Concern

  private

  def record_article_view(article)
    return unless user_signed_in?
    # Turboのリンク先読み(prefetch)ではユーザーの閲覧意図がないため記録しない
    return if prefetch_request?

    view = current_user.article_views.find_or_initialize_by(article: article)
    # 閲覧履歴の記録失敗で画面表示を壊さないため save!ではなくsaveを使用
    view.new_record? ? view.save : view.touch
  end

  # Turbo 8+ は X-Sec-Purpose、標準Fetchは Sec-Purpose を送る。両方をガード。
  def prefetch_request?
    %w[X-Sec-Purpose Sec-Purpose Purpose X-Purpose].any? do |name|
      request.headers[name].to_s.include?("prefetch")
    end
  end
end
