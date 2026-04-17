class Admin::CharactersController < Admin::BaseController
  before_action :set_character, only: %i[edit update destroy]
  before_action :set_form_options, only: %i[new create edit update]

  def index
    @characters = Character.includes(:period, :study_unit, :events)
    @characters = @characters.where(period_id: params[:period_id]) if params[:period_id].present?
    @characters = @characters.where(study_unit_id: params[:study_unit_id]) if params[:study_unit_id].present?
    @characters = @characters.order(updated_at: :desc).page(params[:page]).per(20)
    @periods = Period.all
    @study_units = StudyUnit.all
  end

  def new
    @character = Character.new
  end

  def create
    @character = Character.new(character_params)
    if @character.save
      redirect_to admin_characters_path, notice: "「#{@character.name}」を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @character.update(character_params)
      redirect_to admin_characters_path, notice: "「#{@character.name}」を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @character.destroy!
    redirect_to admin_characters_path, notice: "「#{@character.name}」を削除しました"
  end

  private

  def set_character
    @character = Character.find(params[:id])
  end

  def set_form_options
    @periods = Period.all
    @study_units = StudyUnit.all
    @regions = Region.all
  end

  def character_params
    params.require(:character).permit(:name, :description, :achievement, :year, :period_id, :study_unit_id, :region_id, :image, :image_credit)
  end
end
