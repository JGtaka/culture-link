class QuizResultsController < ApplicationController
  before_action :authenticate_user!

  def create
    @quiz = Quiz.includes(questions: :choices).find(params[:quiz_id])
    answers = params[:answers] || {}

    if @quiz.questions.any? { |q| answers[q.id.to_s].blank? }
      redirect_to quiz_path(@quiz), alert: "すべての問題に回答してください" and return
    end

    quiz_result = nil
    ActiveRecord::Base.transaction do
      quiz_result = QuizResult.find_or_initialize_by(user: current_user, quiz: @quiz)
      quiz_result.assign_attributes(status: :in_progress, test_date: Date.current)
      quiz_result.save!
      quiz_result.question_answers.destroy_all

      correct_count = 0
      @quiz.questions.each do |question|
        selected_choice = question.choices.find(answers[question.id.to_s])
        is_correct = selected_choice.correct_answer
        correct_count += 1 if is_correct
        quiz_result.question_answers.create!(
          question: question,
          choice: selected_choice,
          is_correct: is_correct
        )
      end

      total = @quiz.questions.size
      quiz_result.update!(
        status: :completed,
        correct_count: correct_count,
        total_correct: total,
        score: ((correct_count.to_f / total) * 100).round
      )
    end

    redirect_to quiz_result_path(quiz_result)
  end

  def show
    @quiz_result = current_user.quiz_results
      .includes(quiz: { questions: :choices }, question_answers: [ :question, :choice ])
      .find(params[:id])
    @quiz = @quiz_result.quiz
  end
end
