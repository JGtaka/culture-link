module AdminHelper
  def admin_nav_items
    [
      { label: "ダッシュボード", path: admin_root_path, icon: "admin/shared/icons/dashboard" },
      { label: "人物記事", path: admin_characters_path, icon: "admin/shared/icons/content" },
      { label: "出来事記事", path: admin_events_path, icon: "admin/shared/icons/events" },
      { label: "マスター管理", path: admin_masters_path, icon: "admin/shared/icons/master" },
      { label: "クイズ管理", path: admin_root_path, icon: "admin/shared/icons/quiz" },
      { label: "ユーザー管理", path: admin_root_path, icon: "admin/shared/icons/users" }
    ]
  end
end
