class AnswersController < ApplicationController

  def create
    @answer = Answer.new(answer_params)
    @answer.question = Question.find(params[:question_id])
    scoring
    @answer.save
    @question = @answer.question
    if @question.last?
      redirect_to quiz_path(@question.quiz)
    else
      redirect_to question_path(@question.next_id)
    end
  end

  private

  def scoring
    @selected_option = Option.find(@answer.choice_id)
    if @selected_option.correct
      @answer.score = 1
    else
      @answer.score = 0
    end
  end

  def answer_params
    params.require(:answer).permit(:choice_id)
  end
end
