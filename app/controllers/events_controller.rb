class EventsController < ApplicationController
  include ArticleViewable

  def show
    @event = Event.includes(:period, :category, :region, :study_unit, characters: [ :period, :region ]).find(params[:id])
    record_article_view(@event)
  end
end
