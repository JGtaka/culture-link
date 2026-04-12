class QuizzesController < ApplicationController
  before_action :authenticate_user!

  def index
    @quiz_categories = QuizCategory.order(:id)
    @quizzes = Quiz
      .by_category(params[:quiz_category_id])
      .includes(:quiz_category, :questions, :quiz_results)
      .order(:id)
      .page(params[:page]).per(6)
  end
end
