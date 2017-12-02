class AnswersController < ApplicationController


  def create
    @answer = Answer.new(answer_params)
    @answer.question = Question.find(params[:question_id])
    scoring
    binding.pry
    @answer.save
    @question = @answer.question
    redirect_to question_path(@question.next_id)
  end

  def update
  end

  def destroy
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
