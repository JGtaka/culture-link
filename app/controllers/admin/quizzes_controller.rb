class Admin::QuizzesController < Admin::BaseController
  before_action :set_quiz, only: %i[show edit update destroy publish unpublish]
  before_action :set_form_options, only: %i[new create edit update]
  before_action :set_filter_options, only: %i[index]

  def index
    @quizzes = Quiz.includes(:quiz_category)
                   .by_category(params[:quiz_category_id])
                   .order(updated_at: :desc)
                   .page(params[:page]).per(20)
  end

  def show
    @questions = @quiz.questions.includes(:choices).order(:id)
  end

  def new
    @quiz = Quiz.new
  end

  def create
    @quiz = Quiz.new(quiz_params)
    if @quiz.save
      redirect_to admin_quiz_path(@quiz), notice: "「#{@quiz.title}」を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @quiz.update(quiz_params)
      redirect_to admin_quiz_path(@quiz), notice: "「#{@quiz.title}」を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @quiz.destroy!
    redirect_to admin_quizzes_path, notice: "「#{@quiz.title}」を削除しました"
  end

  def publish
    if @quiz.update(published_at: Time.current)
      redirect_to admin_quiz_path(@quiz), notice: "「#{@quiz.title}」を公開しました"
    else
      redirect_to admin_quiz_path(@quiz), alert: @quiz.errors.full_messages.join(", ")
    end
  end

  def unpublish
    @quiz.update!(published_at: nil)
    redirect_to admin_quiz_path(@quiz), notice: "「#{@quiz.title}」を非公開にしました"
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:id])
  end

  def set_form_options
    @quiz_categories = QuizCategory.order(:name)
  end

  def set_filter_options
    @quiz_categories = QuizCategory.order(:name)
  end

  def quiz_params
    params.require(:quiz).permit(:title, :quiz_category_id, :image, :image_url)
  end
end
