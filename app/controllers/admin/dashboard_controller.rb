class Admin::DashboardController < Admin::BaseController
  def index
    @total_users = User.count
    @monthly_users_count = User.where(created_at: Time.current.beginning_of_month..).count
    @total_articles = Event.count + Character.count
    @total_quizzes = Quiz.count
    @popular_units = popular_study_units
    @recent_users = User.order(created_at: :desc).limit(4)
  end

  private

  def popular_study_units
    StudyUnit.left_joins(events: :article_views)
             .group("study_units.id", "study_units.name")
             .order("COUNT(article_views.id) DESC")
             .limit(5)
             .select("study_units.id", "study_units.name", "COUNT(article_views.id) AS views_count")
  end
end
