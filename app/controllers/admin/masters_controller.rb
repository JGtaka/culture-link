class Admin::MastersController < Admin::BaseController
  def index
    @periods     = Period.order(:name)
    @regions     = Region.order(:name)
    @study_units = StudyUnit.order(:name)
    @new_period     = Period.new
    @new_region     = Region.new
    @new_study_unit = StudyUnit.new
  end
end
