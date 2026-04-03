# 時代
period_medieval = Period.find_or_create_by!(name: "中世")

# カテゴリ
category_event = Category.find_or_create_by!(name: "出来事")

# 学習単元
study_unit = StudyUnit.find_or_create_by!(name: "ルネサンス")

# 出来事
event = Event.find_or_create_by!(title: "イタリア・ルネサンス") do |e|
  e.year = 1400
  e.description = "中世から近代への移行期を象徴するヨーロッパの歴史的時代で、15世紀から16世紀にかけて最盛期を迎えました。"
  e.image_url = "/renaissance.jpg"
  e.period = period_medieval
  e.category = category_event
  e.study_unit = study_unit
end

# 人物
character = Character.find_or_create_by!(name: "レオナルド・ダ・ヴィンチ") do |c|
  c.description = "盛期ルネサンスを代表するイタリアの多才な人物で、画家、彫刻家、建築家、技術者、科学者として活躍しました。"
  c.achievement = "『モナ・リザ』『最後の晩餐』などの傑作を残し、解剖学・工学・天文学など多分野で先駆的な業績を残した。"
  c.image_url = "/leonardo.jpg"
  c.study_unit = study_unit
end

# 出来事と人物の関連付け
EventCharacter.find_or_create_by!(event: event, character: character)

puts "Seed data created successfully!"
