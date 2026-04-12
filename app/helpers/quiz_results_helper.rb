module QuizResultsHelper
  def quiz_result_message(score)
    case score
    when 90..100
      { title: "素晴らしい！", subtitle: "(Excellent!)", body: "文化史への理解がとても深いですね。この調子で学習を続けましょう！" }
    when 70..89
      { title: "よくできました！", subtitle: "(Well done!)", body: "基礎はバッチリです。間違えたところを復習して、さらに理解を深めましょう！" }
    when 50..69
      { title: "もう少し！", subtitle: "(Keep going!)", body: "半分以上できています。解説をしっかり読んで知識を定着させましょう！" }
    else
      { title: "復習しましょう", subtitle: "(Let's review!)", body: "焦らず何度も挑戦して、一つずつ理解を積み重ねていきましょう！" }
    end
  end

  def quiz_result_color(score)
    case score
    when 90..100 then "#22c55e"
    when 70..89  then "#3b82f6"
    when 50..69  then "#ec5b13"
    else              "#ef4444"
    end
  end
end
