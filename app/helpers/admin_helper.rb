module AdminHelper
  def admin_nav_items
    [
      { label: "ダッシュボード", path: admin_root_path, icon: "admin/shared/icons/dashboard" },
      { label: "コンテンツ管理", path: admin_root_path, icon: "admin/shared/icons/content" },
      { label: "クイズ管理", path: admin_root_path, icon: "admin/shared/icons/quiz" },
      { label: "ユーザー管理", path: admin_root_path, icon: "admin/shared/icons/users" }
    ]
  end
end
