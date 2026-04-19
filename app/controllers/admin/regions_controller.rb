class Admin::RegionsController < Admin::BaseController
  before_action :set_region, only: %i[edit update destroy]

  def index
    redirect_to admin_masters_path
  end

  def new
    @region = Region.new
  end

  def create
    @region = Region.new(region_params)
    if @region.save
      redirect_to admin_masters_path, notice: "「#{@region.name}」を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @region.update(region_params)
      redirect_to admin_masters_path, notice: "「#{@region.name}」を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    if @region.destroy
      redirect_to admin_masters_path, notice: "「#{@region.name}」を削除しました"
    else
      redirect_to admin_masters_path, alert: @region.errors.full_messages.join(", ").presence || "削除できませんでした"
    end
  end

  private

  def set_region
    @region = Region.find(params[:id])
  end

  def region_params
    params.require(:region).permit(:name)
  end
end
