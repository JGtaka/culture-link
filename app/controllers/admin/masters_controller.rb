class Admin::MastersController < Admin::BaseController
  def index
    @periods     = Period.order(:name)
    @regions     = Region.order(:name)
    @study_units = StudyUnit.order(:name)
  end
end
