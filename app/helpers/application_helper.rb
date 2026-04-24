module ApplicationHelper
  def page_title(title = nil)
    title = content_for(:title) if title.nil?
    site_name = I18n.t("site_name")
    return site_name if title.blank?

    "#{title} | #{site_name}"
  end
end
