class AnswersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def new; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user

    if @answer.save
      redirect_to question_path(question), notice: 'Your answer successfully created.'
    else
      render 'questions/show'
    end
  end

  def destroy
    answer.destroy if current_user.author?(answer)
    redirect_to question_path(question)
  end

  private

  def question
    @question ||= params[:question_id] ? Question.find(params[:question_id]) : answer.question
  end

  def answer
    @answer ||= params[:id] ? Answer.find(params[:id]) : Answer.new
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body)
  end

end
