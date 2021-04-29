module VotesHelper
  def vote_hidden(resource)
    'hidden' if resource.votes.where(user: current_user).present?
  end

  def delete_vote_hidden(resource)
    'hidden' unless resource.votes.where(user: current_user).present?
  end
end