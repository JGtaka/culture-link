class SchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_schedule, only: [ :edit, :update, :destroy ]

  def new
    @schedule = current_user.schedules.build
    @study_units = StudyUnit.all
  end

  def create
    @schedule = current_user.schedules.build(schedule_params)

    if @schedule.save
      redirect_to profile_path, notice: "スケジュールを作成しました"
    else
      @study_units = StudyUnit.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @study_units = StudyUnit.all
  end

  def update
    if @schedule.update(schedule_params)
      redirect_to profile_path, notice: "スケジュールを更新しました"
    else
      @study_units = StudyUnit.all
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @schedule.destroy
    redirect_to profile_path, notice: "スケジュールを削除しました"
  end

  private

  def set_schedule
    @schedule = current_user.schedules.find(params[:id])
  end

  def schedule_params
    params.require(:schedule).permit(
      :start_date, :end_date, :daily_study_hours, :memo,
      weekdays: [], study_unit_ids: []
    )
  end
end
