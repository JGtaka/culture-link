class Admin::PeriodsController < Admin::BaseController
  before_action :set_period, only: %i[edit update destroy]

  def index
    redirect_to admin_masters_path
  end

  def new
    @period = Period.new
  end

  def create
    @period = Period.new(period_params)
    if @period.save
      redirect_to admin_masters_path, notice: "「#{@period.name}」を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @period.update(period_params)
      redirect_to admin_masters_path, notice: "「#{@period.name}」を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @period.destroy
      redirect_to admin_masters_path, notice: "「#{@period.name}」を削除しました"
    else
      redirect_to admin_masters_path, alert: @period.errors.full_messages.join(", ").presence || "削除できませんでした"
    end
  end

  def reorder
    ids = Array(params[:ids]).map(&:to_i)
    Period.transaction do
      ids.each_with_index do |id, idx|
        Period.where(id: id).update_all(display_order: idx + 1)
      end
    end
    head :ok
  end

  private

  def set_period
    @period = Period.find(params[:id])
  end

  def period_params
    params.require(:period).permit(:name)
  end
end
