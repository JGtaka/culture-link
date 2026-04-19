class Admin::MastersController < Admin::BaseController
  def index
    @periods     = Period.ordered
    @regions     = Region.ordered
    @study_units = StudyUnit.ordered
  end
end
