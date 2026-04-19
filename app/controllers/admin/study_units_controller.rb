class Admin::StudyUnitsController < Admin::BaseController
  before_action :set_study_unit, only: %i[edit update destroy]

  def new
    @study_unit = StudyUnit.new
  end

  def create
    @study_unit = StudyUnit.new(study_unit_params)
    if @study_unit.save
      redirect_to admin_masters_path, notice: "「#{@study_unit.name}」を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @study_unit.update(study_unit_params)
      redirect_to admin_masters_path, notice: "「#{@study_unit.name}」を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @study_unit.destroy
      redirect_to admin_masters_path, notice: "「#{@study_unit.name}」を削除しました"
    else
      redirect_to admin_masters_path, alert: @study_unit.errors.full_messages.join(", ").presence || "削除できませんでした"
    end
  end

  private

  def set_study_unit
    @study_unit = StudyUnit.find(params[:id])
  end

  def study_unit_params
    params.require(:study_unit).permit(:name)
  end
end
