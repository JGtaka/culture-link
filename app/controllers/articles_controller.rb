class ArticlesController < ApplicationController
  def index
    @q_event = Event.ransack(event_search_params)
    @q_character = Character.ransack(character_search_params)

    events = @q_event.result.includes(:period, :category, :region, :study_unit)
    characters = @q_character.result.includes(:period, :region, :study_unit)

    events = apply_filters(events)
    characters = apply_filters(characters)

    all_articles = events + characters
    @articles = Kaminari.paginate_array(all_articles).page(params[:page]).per(6)

    @periods = Period.all
    @study_units = StudyUnit.all
    @regions = Region.all
  end

  private

  def apply_filters(scope)
    scope = scope.where(period_id: params[:period_ids]) if params[:period_ids].present?
    scope = scope.where(study_unit_id: params[:study_unit_id]) if params[:study_unit_id].present?
    scope = scope.where(region_id: params[:region_id]) if params[:region_id].present?
    scope
  end

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
