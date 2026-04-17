class Admin::CharactersController < Admin::BaseController
  before_action :set_character, only: %i[destroy]

  def index
    @characters = Character.includes(:period, :study_unit, :events)
    @characters = @characters.where(period_id: params[:period_id]) if params[:period_id].present?
    @characters = @characters.where(study_unit_id: params[:study_unit_id]) if params[:study_unit_id].present?
    @characters = @characters.order(updated_at: :desc).page(params[:page]).per(20)
    @periods = Period.all
    @study_units = StudyUnit.all
  end

  def destroy
    @character.destroy!
    redirect_to admin_characters_path, notice: "「#{@character.name}」を削除しました"
  end

  private

  def set_character
    @character = Character.find(params[:id])
  end
end
