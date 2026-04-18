class Admin::EventsController < Admin::BaseController
  before_action :set_event, only: %i[edit update destroy]
  before_action :set_filter_options, only: %i[index]
  before_action :set_form_options, only: %i[new create edit update]

  def index
    @events = Event.includes(:period, :category, :region, :study_unit)
                   .by_period(params[:period_id])
                   .by_region(params[:region_id])
                   .by_category(params[:category_id])
                   .order(updated_at: :desc)
                   .page(params[:page]).per(20)
  end

  def new
    @event = Event.new
  end

  def create
    @event = Event.new(event_params)
    if @event.save
      redirect_to admin_events_path, notice: "「#{@event.title}」を作成しました"
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit; end

  def update
    if @event.update(event_params)
      redirect_to admin_events_path, notice: "「#{@event.title}」を更新しました"
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy!
    redirect_to admin_events_path, notice: "「#{@event.title}」を削除しました"
  end

  private

  def set_event
    @event = Event.find(params[:id])
  end

  def set_filter_options
    @periods = Period.all
    @regions = Region.all
    @categories = Category.all
  end

  def set_form_options
    @periods = Period.all
    @regions = Region.all
    @categories = Category.all
    @study_units = StudyUnit.all
    @characters = Character.order(:name)
  end

  def event_params
    permitted = params.require(:event).permit(
      :title, :year, :description,
      :period_id, :category_id, :region_id, :study_unit_id,
      :image, :image_credit,
      character_ids: []
    )
    if permitted.key?(:character_ids)
      permitted[:character_ids] = Character.where(id: permitted[:character_ids]).ids
    end
    permitted
  end
end
