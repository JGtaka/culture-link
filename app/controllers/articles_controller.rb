class ArticlesController < ApplicationController
  def index
    @q_event = Event.ransack(event_search_params)
    @q_character = Character.ransack(character_search_params)

    events = @q_event.result.includes(:period, :category)
    characters = @q_character.result

    all_articles = events + characters
    @articles = Kaminari.paginate_array(all_articles).page(params[:page]).per(6)
  end

  private

  # Event: title, descriptionで検索
  def event_search_params
    return {} unless params[:q].present?
    { title_or_description_cont: params[:q][:keyword] }
  end

  # Character: name, description, achievementで検索
  def character_search_params
    return {} unless params[:q].present?
    { name_or_description_or_achievement_cont: params[:q][:keyword] }
  end
end
