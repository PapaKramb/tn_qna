class AnswersController < ApplicationController
  before_action :authenticate_user!

  def show; end

  def new; end

  def edit; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save
  end

  def update
    answer.update(answer_params) if current_user.author?(answer)
  end

  def destroy
    answer.destroy if current_user.author?(answer)
  end

  def best_answer
    answer.make_best if current_user.author?(question)
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
