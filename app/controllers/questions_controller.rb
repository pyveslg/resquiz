class QuestionsController < ApplicationController
  def show
    @question = Question.find(params[:id])
    @quiz = @question.quiz
  end
end
