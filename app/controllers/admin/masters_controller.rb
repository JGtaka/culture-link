class Admin::MastersController < Admin::BaseController
  def index
    @periods          = Period.ordered
    @regions          = Region.ordered
    @study_units      = StudyUnit.ordered
    @quiz_categories  = QuizCategory.ordered
  end
end
