class QuizzesController < ApplicationController
  before_action :authenticate_user!

  def index
    @quiz_categories = QuizCategory.order(:id)
    @quizzes = Quiz.published
      .by_category(params[:quiz_category_id])
      .includes(:quiz_category, :questions, :quiz_results)
      .order(:id)
      .page(params[:page]).per(6)
  end

  def show
    @quiz = Quiz.published.includes(questions: :choices).find(params[:id])
  end
end
