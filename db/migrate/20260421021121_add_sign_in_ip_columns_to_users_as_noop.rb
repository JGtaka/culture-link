class AddSignInIpColumnsToUsersAsNoop < ActiveRecord::Migration[7.2]
  def change
    # Deviseのtrackableモジュールが要求するIPカラム。値はモデル側のsetterで破棄し、
    # IPアドレスは保存しない設計。private APIに依存せず公開セッターだけで制御するため追加。
    add_column :users, :current_sign_in_ip, :string
    add_column :users, :last_sign_in_ip, :string
  end
end
