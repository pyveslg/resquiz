class QuestionsController < ApplicationController
  before_action :find_question, only: [:show, :previous_question]

  def show
    @question = Question.find(params[:id])
    @quiz = @question.quiz
    if !@question.answers.empty?
      @question.answers.destroy_all
    end
  end


  private

  def find_question
    @question = Question.find(params[:id])
  end


end
