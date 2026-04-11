class ProfilesController < ApplicationController
  before_action :authenticate_user!

  def show
    @schedules = current_user.schedules.includes(:study_units).order(start_date: :asc)
  end
end
