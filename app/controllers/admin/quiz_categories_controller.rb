class Admin::QuizCategoriesController < Admin::BaseController
  before_action :set_quiz_category, only: %i[edit update destroy]

  def index
    redirect_to admin_masters_path
  end

  def new
    @quiz_category = QuizCategory.new
  end

  def create
    @quiz_category = QuizCategory.new(quiz_category_params)
    if @quiz_category.save
      redirect_to admin_masters_path, notice: "「#{@quiz_category.name}」を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @quiz_category.update(quiz_category_params)
      redirect_to admin_masters_path, notice: "「#{@quiz_category.name}」を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @quiz_category.destroy
      redirect_to admin_masters_path, notice: "「#{@quiz_category.name}」を削除しました"
    else
      redirect_to admin_masters_path, alert: @quiz_category.errors.full_messages.join(", ").presence || "削除できませんでした"
    end
  end

  def reorder
    ids = Array(params[:ids]).map(&:to_i)
    QuizCategory.transaction do
      ids.each_with_index do |id, idx|
        QuizCategory.where(id: id).update_all(display_order: idx + 1)
      end
    end
    head :ok
  end

  private

  def set_quiz_category
    @quiz_category = QuizCategory.find(params[:id])
  end

  def quiz_category_params
    params.require(:quiz_category).permit(:name)
  end
end
