class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @schedules = current_user.schedules.includes(:study_units).order(start_date: :asc)
    @quiz_results = current_user.quiz_results
      .completed
      .includes(:quiz)
      .order(updated_at: :desc)
    @quiz_result_pages = @quiz_results.each_slice(3).to_a
  end
end
