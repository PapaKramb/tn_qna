class QuestionsController < ApplicationController
  before_action :authenticate_user!, except: %i[index show]

  after_action :publish_question, only: %i[create]
  after_action :set_question_gon, only: %i[show]

  include Voted

  def index
    @questions = Question.all
  end

  def show
    @answer ||= question.answers.new
    @answer.links.new
    @comment = @question.comments.build(user: current_user)
  end

  def new
    question.links.new
    question.build_reward
  end

  def edit; end

  def create
    @question = current_user.questions.new(question_params)

    if @question.save
      redirect_to @question, notice: 'Your question successfully created.'
    else
      render :new
    end
  end

  def update
    question.update(question_params)
  end

  def destroy
    if current_user.author?(question)
      question.destroy 
      redirect_to questions_path, notice: 'Your question was successfully deleted!'
    else
      redirect_to questions_path, notice: 'Your question was not deleted!'
    end
  end

  private

  def question
    @question ||= params[:id] ? Question.with_attached_files.find(params[:id]) : Question.new
  end

  helper_method :question

  def question_params
    params.require(:question).permit(:title, :body, 
                                      files: [], links_attributes: [:name, :url],
                                      reward_attributes: [:title, :image_url])
  end

  def publish_question
    return if @question.errors.any?
    ActionCable.server.broadcast('questions',{ question: @question, user_id: current_user.id })
  end

  def set_question_gon
    gon.question_id = question.id
  end
end
