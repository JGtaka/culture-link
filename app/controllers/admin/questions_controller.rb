class Admin::QuestionsController < Admin::BaseController
  before_action :set_quiz
  before_action :set_question, only: %i[edit update destroy]

  def new
    @question = @quiz.questions.build
    Question::CHOICES_COUNT.times { @question.choices.build }
  end

  def create
    @question = @quiz.questions.build(question_params)
    if @question.save
      redirect_to admin_quiz_path(@quiz), notice: "問題を追加しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @question.update(question_params)
      redirect_to admin_quiz_path(@quiz), notice: "問題を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @question.destroy!
    redirect_to admin_quiz_path(@quiz), notice: "問題を削除しました"
  end

  private

  def set_quiz
    @quiz = Quiz.find(params[:quiz_id])
  end

  def set_question
    @question = @quiz.questions.find(params[:id])
  end

  def question_params
    params.require(:question).permit(
      :body, :explanation, :correct_choice_index,
      images: [],
      choices_attributes: [ :id, :body ]
    )
  end
end
