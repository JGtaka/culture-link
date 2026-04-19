class TimelinesController < ApplicationController
  def show
    @study_unit = StudyUnit.find(params[:id])
    @study_units = StudyUnit.ordered
    @events = @study_unit.events
      .includes(:category, :period, :region, :characters)
      .order(:year)
    @categories = @events.map(&:category).uniq
  end
end
