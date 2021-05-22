class Api::V1::QuestionsController < Api::V1::BaseController
  before_action :set_question, only: %i[answers show destroy update]

  authorize_resource

  def index
    @questions = Question.all
    render json: @questions, each_serializer: QuestionsSerializer, root: "questions"
  end

  def show
    render json: @question, serializer: QuestionSerializer
  end

  def create
    @question = current_resource_owner.questions.build(question_params)
    
    if @question.save
      render json: @question, serializer: QuestionSerializer
    end
  end

  def update
    if @question.update(question_params)
      render json: @question, serializer: QuestionSerializer
    else
      render json: { message: 'error update', status: 422 }
    end
  end

  def destroy
    @question.destroy
    render json: { message: "question deleted", status: 200 }
  end
  private

  def set_question
    @question ||= Question.find(params[:id])
  end

  def question_params
    params.require(:question).permit(:title, :body, links_attributes: [:name, :url], reward_attributes: [:title, :img_url])
  end
end