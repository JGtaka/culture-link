class FavoritesController < ApplicationController
  before_action :authenticate_user!

  def index
    favorites = current_user.favorites.includes(:favorable)
    all_articles = favorites.map(&:favorable).compact
    @articles = Kaminari.paginate_array(all_articles).page(params[:page]).per(6)
  end

  def create
    @favorite = current_user.favorites.build(favorable_type: params[:favorable_type], favorable_id: params[:favorable_id])

    if @favorite.save
      redirect_back fallback_location: articles_path, notice: "お気に入りに追加しました"
    else
      redirect_back fallback_location: articles_path, alert: "お気に入りの追加に失敗しました"
    end
  end

  def destroy
    @favorite = current_user.favorites.find(params[:id])
    @favorite.destroy
    redirect_back fallback_location: articles_path, notice: "お気に入りを解除しました"
  end
end
