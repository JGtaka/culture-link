class Admin::UsersController < Admin::BaseController
  PER_PAGE = 20
  TABS = %w[quiz_results favorites].freeze

  before_action :set_user, only: %i[show suspend resume]

  def index
    @users = filtered_users.order(created_at: :desc).page(params[:page]).per(PER_PAGE)

    @total_count     = User.count
    @monthly_count   = User.where(created_at: Time.current.beginning_of_month..).count
    @active_count    = User.recently_active.count
    @suspended_count = User.suspended.count
    @prev_month_diff = calc_prev_month_diff
  end

  def show
    @tab = TABS.include?(params[:tab]) ? params[:tab] : "quiz_results"

    case @tab
    when "quiz_results"
      @quiz_results = @user.quiz_results.includes(:quiz).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
    when "favorites"
      @favorites = @user.favorites.includes(:favorable).order(created_at: :desc).page(params[:page]).per(PER_PAGE)
    end
  end

  def suspend
    if @user == current_user
      redirect_to admin_user_path(@user), alert: "自分自身を停止することはできません"
    elsif @user.update(suspended_at: Time.current)
      redirect_to admin_user_path(@user), notice: "「#{@user.name}」を停止しました"
    else
      redirect_to admin_user_path(@user), alert: "停止に失敗しました: #{@user.errors.full_messages.join(', ')}"
    end
  end

  def resume
    if @user.update(suspended_at: nil)
      redirect_to admin_user_path(@user), notice: "「#{@user.name}」の停止を解除しました"
    else
      redirect_to admin_user_path(@user), alert: "解除に失敗しました: #{@user.errors.full_messages.join(', ')}"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def filtered_users
    users = User.all
    users = apply_keyword(users, params[:q])
    users = apply_status(users, params[:status])
    users = apply_period(users, params[:from], params[:to])
    users
  end

  def apply_keyword(relation, keyword)
    return relation if keyword.blank?

    escaped = ActiveRecord::Base.sanitize_sql_like(keyword)
    relation.where("name ILIKE :kw OR email ILIKE :kw", kw: "%#{escaped}%")
  end

  def apply_status(relation, status)
    case status
    when "active"    then relation.active_users
    when "suspended" then relation.suspended
    else relation
    end
  end

  def apply_period(relation, from, to)
    relation = relation.where(created_at: Date.parse(from).beginning_of_day..) if from.present?
    relation = relation.where(created_at: ..Date.parse(to).end_of_day)         if to.present?
    relation
  rescue ArgumentError
    flash.now[:alert] = "日付の形式が正しくありません"
    relation
  end

  def calc_prev_month_diff
    prev_range = 1.month.ago.beginning_of_month..1.month.ago.end_of_month
    prev_count = User.where(created_at: prev_range).count
    return nil if prev_count.zero?

    (((@monthly_count - prev_count) / prev_count.to_f) * 100).round
  end
end
