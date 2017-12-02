class QuizzesController < ApplicationController
  def index
    @quizzes = Quiz.all
  end

  def show
    @quiz = Quiz.find(params[:id])
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

  def delete_answers
    @quiz = Quiz.find(params[:id])
    @quiz.questions.each do |question|
      question.answers.destroy_all
    end
    redirect_to question_path(@quiz.questions.first)
  end

  private

  def result
    sum = 0
    @quiz.answers.each do |answer|
      sum += answer.score
    end
    total = sum.fdiv(@quiz.answers.size) * 100
    @result = total.ceil
  end


end
