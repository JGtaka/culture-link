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
unit_romanticism = StudyUnit.find_or_create_by!(name: "ロマン主義")

# === ルネサンス関連の出来事 ===

event1 = Event.find_or_initialize_by(title: "イタリア・ルネサンス")
event1.update!(
  year: 1400,
  description: "14世紀末のイタリアで始まった文化・芸術・学問の大変革運動。古代ギリシャ・ローマの古典文化を再発見し、人間中心の世界観（ヒューマニズム）を生み出した。フィレンツェのメディチ家をはじめとするパトロンの支援のもと、絵画・彫刻・建築・文学・科学など多くの分野で革新的な発展を遂げた。この運動は15〜16世紀に最盛期を迎え、やがてアルプスを越えてヨーロッパ各地に広がり、近代への扉を開いた。",
  image_url: "/renaissance.jpg",
  image_credit: "https://commons.wikimedia.org/wiki/File:Sandro_Botticelli_046.jpg",
  period: period_medieval,
  category: category_event,
  study_unit: unit_renaissance,
  region: region_europe
)

event3 = Event.find_or_initialize_by(title: "システィーナ礼拝堂天井画の完成")
event3.update!(
  year: 1512,
  description: "教皇ユリウス2世の依頼を受けたミケランジェロが、1508年から約4年の歳月をかけて完成させた壮大なフレスコ画。約500平方メートルの天井に、旧約聖書の「天地創造」から「ノアの洪水」までの物語が9つの場面で描かれている。中でも『アダムの創造』は、神とアダムの指先が触れ合う瞬間を描いた人類史上最も有名なイメージの一つ。ミケランジェロは足場の上で仰向けになりながら描き続け、完成時には視力が著しく低下したと伝えられている。",
  image_url: "/sistine_chapel.jpg",
  image_credit: "https://commons.wikimedia.org/wiki/File:Sistine_Chapel_ceiling_03.jpg,-著者： Antoine Taveneaux-, -リサイズ-,-ライセンス：CC BY-SA 3.0-",
  period: period_medieval,
  category: category_art,
  study_unit: unit_renaissance,
  region: region_europe
)

event4 = Event.find_or_initialize_by(title: "グーテンベルクの活版印刷")
event4.update!(
  year: 1450,
  description: "ドイツのマインツでヨハネス・グーテンベルクが実用的な活版印刷技術を開発。金属製の活字を組み合わせて印刷する方式により、書物の大量生産が初めて可能になった。最初の大規模な印刷物は通称「グーテンベルク聖書」（42行聖書）で、約180部が制作された。この技術革新により、それまで修道院で手書き写本されていた知識が急速に広まり、ルネサンスの思想普及、宗教改革、科学革命を支える基盤となった。「印刷革命」とも呼ばれ、情報伝達の歴史を根本的に変えた。",
  image_url: "/gutenberg.jpg",
  image_credit: "https://commons.wikimedia.org/wiki/File:Prensa_de_imprenta.jpg,-著者：Amfeli-, -リサイズ-,-ライセンス：CC BY-SA 3.0-",
  period: period_medieval,
  category: category_event,
  study_unit: unit_renaissance,
  region: region_europe
)

event7 = Event.find_or_initialize_by(title: "『神曲』の執筆")
event7.update!(
  year: 1308,
  description: "フィレンツェ出身の詩人ダンテ・アリギエーリが、政治的追放の中で約13年をかけて完成させた叙事詩。「地獄篇」「煉獄篇」「天国篇」の三部構成で、計100歌・約14,000行からなる。ダンテ自身が古代ローマの詩人ウェルギリウスに導かれて冥界を旅する物語で、当時の政治家や聖職者への痛烈な批判も含まれている。ラテン語ではなくトスカーナ方言（イタリア語の原型）で書かれたことが画期的であり、イタリア文語の基礎を築いた。ルネサンスの先駆けとなる中世文学の最高傑作。",
  image_url: "/divine_comedy.jpg",
  image_credit: "https://commons.wikimedia.org/wiki/File:Dante_et_la_Divine_Com%C3%A9die-edit.jpg,-著者：Heroldius, edited by MenkinAlRire-, -リサイズ-,-ライセンス：CC BY-SA 3.0-",
  period: period_medieval,
  category: category_literature,
  study_unit: unit_renaissance,
  region: region_europe
)

event8 = Event.find_or_initialize_by(title: "モナ・リザの制作")
event8.update!(
  year: 1503,
  description: "レオナルド・ダ・ヴィンチが1503年頃から数年をかけて制作した油彩画。モデルはフィレンツェの商人フランチェスコ・デル・ジョコンドの妻リザ・ゲラルディーニとされる。輪郭線を用いず色彩の微妙なグラデーションで立体感を出す「スフマート技法」の最高傑作であり、見る角度によって変化するように感じられる神秘的な微笑みが特徴。背景には空気遠近法による幻想的な風景が広がる。現在はパリのルーヴル美術館に所蔵され、世界で最も有名な絵画として年間約1,000万人が鑑賞に訪れる。",
  image_url: "/mona_lisa.jpg",
  image_credit: "https://commons.wikimedia.org/wiki/File:Mona_Lisa,_by_Leonardo_da_Vinci,_from_C2RMF_retouched.jpg",
  period: period_medieval,
  category: category_art,
  study_unit: unit_renaissance,
  region: region_europe
)

event9 = Event.find_or_initialize_by(title: "最後の晩餐の制作")
event9.update!(
  year: 1495,
  description: "レオナルド・ダ・ヴィンチがミラノのサンタ・マリア・デッレ・グラツィエ修道院の食堂壁面に描いた大作。横約9m・縦約4.5mの巨大な壁画で、イエス・キリストが十二使徒に「この中に裏切り者がいる」と告げた瞬間の劇的な場面を描いている。一点透視図法を完璧に駆使し、画面の消失点がイエスの頭部に集約される構図が見事。各使徒の驚き・怒り・悲しみといった感情が、身振りや表情で生き生きと表現されている。従来のフレスコ技法ではなくテンペラ技法で描かれたため、完成直後から劣化が始まり、数世紀にわたる修復の歴史を持つ。",
  image_url: "/last_supper.jpg",
  image_credit: "",
  period: period_medieval,
  category: category_art,
  study_unit: unit_renaissance,
  region: region_europe
)

event10 = Event.find_or_initialize_by(title: "ウィトルウィウス的人体図")
event10.update!(
  year: 1490,
  description: "レオナルド・ダ・ヴィンチが古代ローマの建築家ウィトルウィウスの著書『建築論』に基づいて描いたペンとインクによるドローイング。円と正方形の中に両手両足を広げた裸体の男性像が描かれ、人体の理想的なプロポーション（黄金比）を数学的・幾何学的に表現している。例えば、身長は両腕を広げた長さに等しく、顔の長さは身長の10分の1であるなど、精密な比率が書き込まれている。芸術と科学、人文学が融合したルネサンス精神の象徴であり、現在もイタリアの1ユーロ硬貨のデザインに使用されている。",
  image_url: "/vitruvian_man.jpg",
  image_credit: "https://commons.wikimedia.org/wiki/File:Da_Vinci_Vitruve_Luc_Viatour.jpg",
  period: period_medieval,
  category: category_art,
  study_unit: unit_renaissance,
  region: region_europe
)

# === その他の出来事 ===

event6 = Event.find_or_initialize_by(title: "フランス革命と芸術")
event6.update!(
  year: 1789,
  description: "1789年に始まったフランス革命は、政治体制だけでなく芸術・文化にも根本的な変革をもたらした。革命の理念「自由・平等・博愛」は芸術家たちに強い影響を与え、ダヴィッドに代表される新古典主義から、感情と個人の自由を重視するロマン主義への転換を促した。ドラクロワの『民衆を導く自由の女神』はこの時代精神を象徴する作品である。",
  period: period_modern,
  category: category_event,
  study_unit: unit_romanticism,
  region: region_europe
)

# === ルネサンス関連の人物 ===

char1 = Character.find_or_initialize_by(name: "レオナルド・ダ・ヴィンチ")
char1.update!(
  description: "1452年イタリア・ヴィンチ村に生まれた「万能の天才」。画家としてだけでなく、彫刻家、建築家、音楽家、数学者、工学者、発明家、解剖学者、地質学者、植物学者と、あらゆる分野で卓越した才能を発揮した。フィレンツェでヴェロッキオに師事し、その後ミラノ、ローマ、フランスで活動。左利きで鏡文字を用いてノートを記し、残された手稿は約13,000ページに及ぶ。好奇心と観察力に基づく科学的アプローチは時代を数世紀先取りしており、ヘリコプターや戦車の設計図なども残している。67歳でフランスのアンボワーズにて没した。",
  achievement: "絵画では『モナ・リザ』『最後の晩餐』『受胎告知』『岩窟の聖母』など、美術史上最も重要な作品群を残した。スフマート技法（輪郭線を使わない描画法）や空気遠近法を確立し、絵画表現を革新した。科学分野では、人体解剖図を700点以上作成して解剖学の発展に貢献。飛行機械、パラシュート、集光型太陽熱利用装置などの設計図を残し、その多くが後世に実現された。「ルネサンス人」（万能人）の理想を体現した人物として、500年以上経った今も世界中で敬愛されている。",
  image_url: "/leonardo.jpg",
  image_credit: "geminiで生成された画像",
  study_unit: unit_renaissance,
  period: period_medieval,
  region: region_europe,
  year: 1452
)

char2 = Character.find_or_initialize_by(name: "ミケランジェロ")
char2.update!(
  description: "1475年イタリア・カプレーゼに生まれた盛期ルネサンスの巨匠。本名はミケランジェロ・ディ・ロドヴィーコ・ブオナローティ・シモーニ。幼少期からフィレンツェで芸術を学び、メディチ家のロレンツォ・イル・マニフィコに才能を見出された。彫刻家として出発し、やがて画家・建築家・詩人としても活躍。89歳まで生き、最晩年までサン・ピエトロ大聖堂の設計に携わるなど、生涯を通じて創作活動を続けた。同時代のダ・ヴィンチとはライバル関係にあり、二人の競争がルネサンス芸術の発展を牽引した。",
  achievement: "彫刻では25歳で制作した『ピエタ』、29歳の『ダビデ像』（高さ5.17m）がルネサンス彫刻の最高傑作とされる。絵画では教皇ユリウス2世の依頼によるシスティーナ礼拝堂天井画（1508-1512年）と、同礼拝堂祭壇壁面の『最後の審判』（1536-1541年）を制作。建築ではサン・ピエトロ大聖堂のドーム設計を手がけた。詩人としても約300編の詩を残している。「彫刻は大理石の中に閉じ込められた像を解放すること」という名言でも知られ、人間の肉体美と精神性を追求した作品は後世の芸術家に計り知れない影響を与えた。",
  image_url: "/michelangelo.jpg",
  image_credit: "geminiで生成された画像",
  study_unit: unit_renaissance,
  period: period_medieval,
  region: region_europe,
  year: 1475
)

char5 = Character.find_or_initialize_by(name: "ダンテ・アリギエーリ")
char5.update!(
  description: "1265年フィレンツェに生まれた中世末期〜ルネサンス初期の詩人・政治家・哲学者。フィレンツェの政治に積極的に関与したが、政争に敗れて1302年に追放され、以後二度と故郷に戻ることはなかった。幼少期に出会ったベアトリーチェへの純粋な愛が、生涯を通じて創作の原動力となった。トスカーナ方言（現代イタリア語の基礎）で作品を書くことで、ラテン語が支配していた文学の世界に革命を起こした。1321年ラヴェンナにて56歳で没。",
  achievement: "最大の業績は叙事詩『神曲』（La Divina Commedia）。「地獄篇」「煉獄篇」「天国篇」の三部・計100歌で構成され、ダンテ自身が古代の詩人ウェルギリウスとベアトリーチェに導かれて死後の世界を旅する壮大な物語。当時の神学・哲学・科学・政治を網羅する百科全書的作品であり、同時代の人物を実名で登場させた大胆な構成でも知られる。他に『新生』（ベアトリーチェへの愛を綴った散文と詩の混合作品）、『饗宴』『俗語論』などの著作がある。「イタリア文学の父」と称され、ペトラルカ、ボッカッチョと共に「イタリア文学の三大巨匠」に数えられる。",
  image_url: "/dante.jpg",
  image_credit: "geminiで生成された画像",
  study_unit: unit_renaissance,
  period: period_medieval,
  region: region_europe,
  year: 1265
)

# === その他の人物 ===

char6 = Character.find_or_initialize_by(name: "ウジェーヌ・ドラクロワ")
char6.update!(
  description: "フランス・ロマン主義を代表する画家。色彩の魔術師と呼ばれ、力強い筆致と鮮烈な色使いで感情表現を追求した。",
  achievement: "『民衆を導く自由の女神』（1830年）を制作し、ロマン主義絵画の象徴的存在となった。この作品は後にフランスの象徴として紙幣や切手にも使用された。",
  study_unit: unit_romanticism,
  period: period_modern,
  region: region_europe,
  year: 1798
)

# === 出来事と人物の関連付け ===
EventCharacter.find_or_create_by!(event: event1, character: char1)
EventCharacter.find_or_create_by!(event: event1, character: char2)
EventCharacter.find_or_create_by!(event: event8, character: char1)
EventCharacter.find_or_create_by!(event: event9, character: char1)
EventCharacter.find_or_create_by!(event: event10, character: char1)
EventCharacter.find_or_create_by!(event: event3, character: char2)
EventCharacter.find_or_create_by!(event: event4, character: char1)
EventCharacter.find_or_create_by!(event: event7, character: char5)
EventCharacter.find_or_create_by!(event: event6, character: char6)

# === 小テスト（クイズ） ===
quiz_cat_renaissance = QuizCategory.find_or_create_by!(name: "ルネサンス")
quiz_cat_romanticism = QuizCategory.find_or_create_by!(name: "ロマン主義")

quiz_data = [
  {
    title: "ルネサンスの文化と芸術",
    category: quiz_cat_renaissance,
    image_url: "/quiz_images/renaissance.jpg",
    questions: [
      {
        body: "ルネサンスが最初に始まったイタリアの都市はどこか？",
        explanation: "ルネサンスは14世紀のフィレンツェで始まりました。メディチ家などの富裕な商人がパトロンとなり、芸術家や学者を支援したことで文化的な大変革が起こりました。",
        image_url: "/renaissance.jpg",
        image_credit: "https://commons.wikimedia.org/wiki/File:Sandro_Botticelli_046.jpg",
        choices: [ [ "フィレンツェ", true ], [ "ローマ", false ], [ "ヴェネツィア", false ], [ "ミラノ", false ] ]
      },
      {
        body: "『モナ・リザ』を描いた画家は誰か？",
        explanation: "『モナ・リザ』はレオナルド・ダ・ヴィンチが1503年頃から制作した油彩画です。輪郭線を用いずに立体感を出す「スフマート技法」が特徴で、世界で最も有名な絵画の一つです。",
        image_url: "/mona_lisa.jpg",
        image_credit: "https://commons.wikimedia.org/wiki/File:Mona_Lisa,_by_Leonardo_da_Vinci,_from_C2RMF_retouched.jpg",
        choices: [ [ "ミケランジェロ", false ], [ "ラファエロ", false ], [ "レオナルド・ダ・ヴィンチ", true ], [ "ボッティチェリ", false ] ]
      },
      {
        body: "システィーナ礼拝堂の天井画を描いた芸術家は？",
        explanation: "ミケランジェロが1508年から約4年をかけて描きました。『アダムの創造』をはじめ、旧約聖書の物語が9つの場面で描かれています。",
        image_url: "/sistine_chapel.jpg",
        image_credit: "https://commons.wikimedia.org/wiki/File:Sistine_Chapel_ceiling_03.jpg,-著者： Antoine Taveneaux-, -リサイズ-,-ライセンス：CC BY-SA 3.0-",
        choices: [ [ "ミケランジェロ", true ], [ "ドナテッロ", false ], [ "ブルネレスキ", false ], [ "ジョット", false ] ]
      }
    ]
  },
  {
    title: "ロマン主義の絵画",
    category: quiz_cat_romanticism,
    image_url: "/quiz_images/romanticism.jpg",
    questions: [
      {
        body: "『民衆を導く自由の女神』を描いた画家は？",
        explanation: "ウジェーヌ・ドラクロワが1830年の七月革命を題材に描いたロマン主義の代表作です。フランスの象徴として、紙幣や切手のデザインにも使われました。",
        choices: [ [ "ダヴィッド", false ], [ "アングル", false ], [ "ドラクロワ", true ], [ "クールベ", false ] ]
      }
    ]
  }
]

quiz_data.each do |data|
  quiz = Quiz.find_or_initialize_by(title: data[:title])
  quiz.update!(quiz_category: data[:category], image_url: data[:image_url])

  data[:questions].each do |q_data|
    question = quiz.questions.find_or_initialize_by(body: q_data[:body])
    question.explanation = q_data[:explanation]
    question.image_url = q_data[:image_url]
    question.image_credit = q_data[:image_credit]
    question.save!

    q_data[:choices].each do |body, correct|
      next if question.choices.exists?(body: body)
      question.choices.create!(body: body, correct_answer: correct)
    end
  end
end

puts "Seed data created successfully!"
puts "Events: #{Event.count}, Characters: #{Character.count}, EventCharacters: #{EventCharacter.count}"
puts "QuizCategories: #{QuizCategory.count}, Quizzes: #{Quiz.count}, Questions: #{Question.count}, Choices: #{Choice.count}"
