module ApplicationHelper
  MARKDOWN_RENDERER = Redcarpet::Markdown.new(
    Redcarpet::Render::HTML.new(
      hard_wrap: true,
      link_attributes: { rel: "noopener noreferrer", target: "_blank" }
    ),
    autolink: true,
    tables: true,
    fenced_code_blocks: true,
    strikethrough: true,
    no_intra_emphasis: true,
    space_after_headers: true
  )

  MARKDOWN_SANITIZE_CONFIG = Sanitize::Config.merge(
    Sanitize::Config::RELAXED,
    attributes: Sanitize::Config::RELAXED[:attributes].merge(
      "a" => Sanitize::Config::RELAXED[:attributes]["a"] + [ "target" ]
    )
  )

  def page_title(title = nil)
    title = content_for(:title) if title.nil?
    site_name = I18n.t("site_name")
    return site_name if title.blank?

    "#{title} | #{site_name}"
  end

  def render_markdown(text)
    return "" if text.blank?

    html = MARKDOWN_RENDERER.render(text)
    Sanitize.fragment(html, MARKDOWN_SANITIZE_CONFIG).html_safe
  end

  def markdown_to_plain(text)
    return "" if text.blank?

    html = MARKDOWN_RENDERER.render(text)
    Sanitize.fragment(html).squish
  end
end
