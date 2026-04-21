class Admin::UsersController < Admin::BaseController
  PER_PAGE = 20

  def index
    @users = filtered_users.order(created_at: :desc).page(params[:page]).per(PER_PAGE)

    @total_count     = User.count
    @monthly_count   = User.where(created_at: Time.current.beginning_of_month..).count
    @active_count    = User.recently_active.count
    @suspended_count = User.suspended.count
    @prev_month_diff = calc_prev_month_diff
  end

  private

  def filtered_users
    users = User.all
    users = apply_keyword(users, params[:q])
    users = apply_status(users, params[:status])
    users = apply_period(users, params[:from], params[:to])
    users
  end

  def apply_keyword(relation, keyword)
    return relation if keyword.blank?

    relation.where("name ILIKE :kw OR email ILIKE :kw", kw: "%#{keyword}%")
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
    relation
  end

  def calc_prev_month_diff
    prev_range = 1.month.ago.beginning_of_month..1.month.ago.end_of_month
    prev_count = User.where(created_at: prev_range).count
    return nil if prev_count.zero?

    (((@monthly_count - prev_count) / prev_count.to_f) * 100).round
  end
end
