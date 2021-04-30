module Voted
  extend ActiveSupport::Concern

  included do
    before_action :authenticate_user!, only: %i[ vote_up vote_down delete_vote ]
    before_action :votable,            only: %i[ vote_up vote_down delete_vote ]
  end

  def vote_up    
    create_vote(1)
  end

  def vote_down    
    create_vote(-1)
  end

  def delete_vote
    respond_to do |format|
      @votable.votes.find_by(user: current_user)&.destroy
      format.json { render json:  { rating: @votable.rating } }
    end
  end

  private

  def model_klass
    controller_name.classify.constantize
  end

  def votable
    @votable ||= model_klass.find(params[:id])
  end

  def create_vote(vote_value)
    respond_to do |format|
      @vote = @votable.votes.build(user: current_user, value: vote_value)
      if @vote.save
        format.json { render json:  { rating: @votable.rating } }
      else
        format.json do 
          render json: @vote.errors.full_messages,status: :unprocessable_entity 
        end
      end  
    end
  end
end