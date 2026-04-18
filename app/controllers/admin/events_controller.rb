class Admin::EventsController < Admin::BaseController
  before_action :set_event, only: %i[destroy]
  before_action :set_filter_options, only: %i[index]

  def index
    @events = Event.includes(:period, :category, :region, :study_unit)
                   .by_period(params[:period_id])
                   .by_region(params[:region_id])
                   .by_category(params[:category_id])
                   .order(updated_at: :desc)
                   .page(params[:page]).per(20)
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
end
