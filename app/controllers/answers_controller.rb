class AnswersController < ApplicationController
  def show; end

  def new; end

  def create
    @answer = question.answers.new(answer_params)

    if @answer.save
      redirect_to answer_path(@answer)
    else
      render :new
    end
  end

  private

  def question
    Question.find(params[:question_id])
  end

  def answer_params
    params.require(:answer).permit(:body)
  end

end
