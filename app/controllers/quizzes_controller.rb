class QuizzesController < ApplicationController
  before_action :find_quiz, only: [:show, :retake]

  def index
    @quizzes = Quiz.all
  end

  def show
    if @quiz.played?
      if @quiz.finished?
        result
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

  def result
    sum = 0
    @quiz.answers.each do |answer|
      sum += answer.score
    end
    total = sum.fdiv(@quiz.answers.size) * 100
    @result = total.ceil
  end

  def delete_answers
    @quiz.questions.each do |question|
      question.answers.destroy_all
    end
    redirect_to question_path(@quiz.questions.first)
  end


end
