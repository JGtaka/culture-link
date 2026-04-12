module QuizzesHelper
  def quiz_button_for(quiz, user)
    case quiz.status_for(user)
    when :completed
      { label: "もう一度受ける", class: "bg-[#f1f5f9] text-[#64748b]" }
    when :in_progress
      { label: "テストを再開する", class: "bg-[#ec5b13]/10 text-[#ec5b13]" }
    else
      { label: "テストを開始する", class: "bg-[#ec5b13] text-white hover:bg-[#d14e0a]" }
    end
  end

  def quiz_status_badge(quiz, user)
    case quiz.status_for(user)
    when :completed
      { label: "完了", class: "bg-[#f0fdf4] text-[#16a34a]" }
    when :in_progress
      { label: "進行中", class: "bg-[#fff7ed] text-[#ec5b13]" }
    end
  end
end
