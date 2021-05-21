# frozen_string_literal: true

class Ability
  include CanCan::Ability

  attr_reader :user

  def initialize(user)
    @user = user

    if user
      user.admin? ? admin_abilities : user_abilities
    else
      guset_abilities
    end
  end

  def guset_abilities
    can :read, :all
  end

  def admin_abilities
    can :manage, :all
  end

  def user_abilities
    guset_abilities
    can :create, [Question, Answer, Comment]
    can [:update,:destroy], [Question, Answer], { user_id: user.id }
    can :rewards, User, { user_id: user.id }

    can :destroy, Link do |link|
      user.author?(link.linkable)
    end
  
    can :destroy, ActiveStorage::Attachment do |file|
      user.author?(file.record)
    end
  
    can [:vote_up, :vote_down], [Question, Answer] do |votable|
      !user.author?(votable)
    end
  
    can :delete_vote, [Question, Answer] do |votable|
      votable.votes.find_by(user_id: user.id)
    end

    can :best_answer, Answer do |answer|
      user.author?(answer.question)
    end

    can :me, User do |profile|
      profile.id == user.id
    end
  end
end
