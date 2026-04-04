# 時代
period_ancient = Period.find_or_create_by!(name: "古代")
period_medieval = Period.find_or_create_by!(name: "中世")
period_early_modern = Period.find_or_create_by!(name: "近世")
period_modern = Period.find_or_create_by!(name: "近代")

# カテゴリ
category_event = Category.find_or_create_by!(name: "出来事")
category_art = Category.find_or_create_by!(name: "芸術")
category_literature = Category.find_or_create_by!(name: "文学")
category_music = Category.find_or_create_by!(name: "音楽")

# 地域
region_europe = Region.find_or_create_by!(name: "ヨーロッパ")
region_middle_east = Region.find_or_create_by!(name: "中東")
region_east_asia = Region.find_or_create_by!(name: "東アジア")
region_south_asia = Region.find_or_create_by!(name: "南アジア")

# 学習単元
unit_renaissance = StudyUnit.find_or_create_by!(name: "ルネサンス")
unit_greek = StudyUnit.find_or_create_by!(name: "古代ギリシャ文化")
unit_baroque = StudyUnit.find_or_create_by!(name: "バロック")
unit_romanticism = StudyUnit.find_or_create_by!(name: "ロマン主義")

# === 出来事 ===

event1 = Event.find_or_create_by!(title: "イタリア・ルネサンス") do |e|
  e.year = 1400
  e.description = "中世から近代への移行期を象徴するヨーロッパの歴史的時代で、15世紀から16世紀にかけて最盛期を迎えました。"
  e.image_url = "/renaissance.jpg"
  e.period = period_medieval
  e.category = category_event
  e.study_unit = unit_renaissance
  e.region = region_europe
end

event2 = Event.find_or_create_by!(title: "パルテノン神殿の建設") do |e|
  e.year = -447
  e.description = "アテネのアクロポリスに建てられた古代ギリシャの神殿。ドーリア式建築の最高傑作とされる。"
  e.period = period_ancient
  e.category = category_art
  e.study_unit = unit_greek
  e.region = region_europe
end

event3 = Event.find_or_create_by!(title: "システィーナ礼拝堂天井画の完成") do |e|
  e.year = 1512
  e.description = "ミケランジェロが約4年をかけて完成させた天井画。『アダムの創造』などの場面が描かれている。"
  e.period = period_medieval
  e.category = category_art
  e.study_unit = unit_renaissance
  e.region = region_europe
end

event4 = Event.find_or_create_by!(title: "グーテンベルクの活版印刷") do |e|
  e.year = 1450
  e.description = "ヨハネス・グーテンベルクが活版印刷技術を発明。知識の普及と宗教改革に大きな影響を与えた。"
  e.period = period_medieval
  e.category = category_event
  e.study_unit = unit_renaissance
  e.region = region_europe
end

event5 = Event.find_or_create_by!(title: "バロック音楽の隆盛") do |e|
  e.year = 1600
  e.description = "装飾的で劇的な表現を特徴とする音楽様式が発展。オペラの誕生もこの時代に起こった。"
  e.period = period_early_modern
  e.category = category_music
  e.study_unit = unit_baroque
  e.region = region_europe
end

event6 = Event.find_or_create_by!(title: "フランス革命と芸術") do |e|
  e.year = 1789
  e.description = "フランス革命は芸術にも大きな影響を与え、新古典主義からロマン主義への転換を促した。"
  e.period = period_modern
  e.category = category_event
  e.study_unit = unit_romanticism
  e.region = region_europe
end

event7 = Event.find_or_create_by!(title: "『神曲』の執筆") do |e|
  e.year = 1308
  e.description = "ダンテ・アリギエーリによる叙事詩。地獄・煉獄・天国の三部構成で、中世文学の最高傑作とされる。"
  e.period = period_medieval
  e.category = category_literature
  e.study_unit = unit_renaissance
  e.region = region_europe
end

# === 人物 ===

char1 = Character.find_or_create_by!(name: "レオナルド・ダ・ヴィンチ") do |c|
  c.description = "盛期ルネサンスを代表するイタリアの多才な人物で、画家、彫刻家、建築家、技術者、科学者として活躍しました。"
  c.achievement = "『モナ・リザ』『最後の晩餐』などの傑作を残し、解剖学・工学・天文学など多分野で先駆的な業績を残した。"
  c.image_url = "/leonardo.jpg"
  c.study_unit = unit_renaissance
  c.period = period_medieval
  c.region = region_europe
  c.year = 1452
end

char2 = Character.find_or_create_by!(name: "ミケランジェロ") do |c|
  c.description = "イタリア・ルネサンス期の彫刻家・画家・建築家。"
  c.achievement = "『ダビデ像』『システィーナ礼拝堂天井画』『ピエタ』などを制作。"
  c.study_unit = unit_renaissance
  c.period = period_medieval
  c.region = region_europe
  c.year = 1475
end

char3 = Character.find_or_create_by!(name: "ソクラテス") do |c|
  c.description = "古代ギリシャの哲学者。西洋哲学の基礎を築いた人物。"
  c.achievement = "対話法（問答法）を確立し、プラトンやアリストテレスに多大な影響を与えた。"
  c.study_unit = unit_greek
  c.period = period_ancient
  c.region = region_europe
  c.year = -470
end

char4 = Character.find_or_create_by!(name: "ヨハン・セバスティアン・バッハ") do |c|
  c.description = "ドイツのバロック音楽の作曲家。「音楽の父」と称される。"
  c.achievement = "『マタイ受難曲』『平均律クラヴィーア曲集』など、バロック音楽の集大成となる作品を残した。"
  c.study_unit = unit_baroque
  c.period = period_early_modern
  c.region = region_europe
  c.year = 1685
end

char5 = Character.find_or_create_by!(name: "ダンテ・アリギエーリ") do |c|
  c.description = "中世イタリアの詩人。イタリア文学の父と呼ばれる。"
  c.achievement = "叙事詩『神曲』を執筆し、イタリア語の文語としての地位を確立した。"
  c.study_unit = unit_renaissance
  c.period = period_medieval
  c.region = region_europe
  c.year = 1265
end

char6 = Character.find_or_create_by!(name: "ウジェーヌ・ドラクロワ") do |c|
  c.description = "フランス・ロマン主義を代表する画家。"
  c.achievement = "『民衆を導く自由の女神』を制作し、ロマン主義絵画の象徴的存在となった。"
  c.study_unit = unit_romanticism
  c.period = period_modern
  c.region = region_europe
  c.year = 1798
end

# === 出来事と人物の関連付け ===
EventCharacter.find_or_create_by!(event: event1, character: char1)
EventCharacter.find_or_create_by!(event: event3, character: char2)
EventCharacter.find_or_create_by!(event: event5, character: char4)
EventCharacter.find_or_create_by!(event: event7, character: char5)
EventCharacter.find_or_create_by!(event: event6, character: char6)

puts "Seed data created successfully!"
puts "Events: #{Event.count}, Characters: #{Character.count}, 合計: #{Event.count + Character.count}"
