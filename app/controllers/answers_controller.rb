class AnswersController < ApplicationController
  before_action :authenticate_user!

  after_action :publish_answer, only: %i[create]
  after_action :set_answer_gon, only: %i[create]

  include Voted

  def show; end

  def new; end

  def edit; end

  def create
    @answer = question.answers.new(answer_params)
    @answer.user = current_user
    @answer.save

    respond_to do |format|
      if @answer.save
        format.json { render json: @answer }
      else
        format.json do 
          render json: @answer.errors.full_messages, status: :unprocessable_entity
        end
      end
    end
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
    @answer ||= params[:id] ? Answer.with_attached_files.find(params[:id]) : Answer.new
  end

  helper_method :question, :answer

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:name, :url])
  end

  def publish_answer
    return if @answer.errors.any?
    ActionCable.server.broadcast("questions/#{params[:question_id]}/answers", answer: @answer, user_id: current_user.id)
  end

  def set_answer_gon
    gon.answer_id = answer.id
  end

end
