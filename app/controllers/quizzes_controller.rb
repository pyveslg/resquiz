class QuizzesController < ApplicationController
  before_action :find_quiz, only: [:show, :retake]

  def index
    @quizzes = Quiz.all
  end

  def show
    if @quiz.played?
      if @quiz.finished?
        @result = @quiz.result
        @incorrect_answers = @quiz.incorrect_answers
      else
        delete_answers
      end
    else
      redirect_to question_path(@quiz.questions.first)
    end
  end

  def retake
    delete_answers
  end

  private

  def find_quiz
    @quiz = Quiz.find(params[:id])
  end

  def delete_answers
    @quiz.questions.each do |question|
      question.answers.destroy_all
    end
    redirect_to question_path(@quiz.questions.first)
  end


end
