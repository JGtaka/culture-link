class CharactersController < ApplicationController
  include ArticleViewable

  def show
    @character = Character.includes(:period, :region, :study_unit, events: [ :category, :period, :region ]).find(params[:id])
    record_article_view(@character)
  end
end
