class ArticlesController < ApplicationController
  def index
    events = Event.includes(:period, :category).all
    characters = Character.all
    @articles = events + characters
  end
end
