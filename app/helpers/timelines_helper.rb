module TimelinesHelper
  CATEGORY_COLORS = {
    "出来事" => { bg: "#dbeafe", border: "#93c5fd", text: "#2563eb" },
    "芸術"  => { bg: "#dcfce7", border: "#86efac", text: "#16a34a" },
    "文学"  => { bg: "#f3e8ff", border: "#d8b4fe", text: "#9333ea" },
    "音楽"  => { bg: "#fef3c7", border: "#fcd34d", text: "#d97706" }
  }.freeze

  DEFAULT_COLOR = { bg: "#f3f4f6", border: "#d1d5db", text: "#4b5563" }.freeze

  def category_colors(category)
    CATEGORY_COLORS[category.name] || DEFAULT_COLOR
  end

  def category_badge_style(category)
    colors = category_colors(category)
    "background-color: #{colors[:bg]}; color: #{colors[:text]};"
  end

  def category_legend_style(category)
    colors = category_colors(category)
    "background-color: #{colors[:bg]}; border-color: #{colors[:border]};"
  end
end
