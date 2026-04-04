class ArticlesController < ApplicationController
  def index
    events = Event.includes(:period, :category).all
    characters = Character.all
    all_articles = events + characters
    @articles = Kaminari.paginate_array(all_articles).page(params[:page]).per(6)
  end
end
