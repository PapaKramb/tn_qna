class Answer < ApplicationRecord
  include Votable
  
  belongs_to :user
  belongs_to :question
  has_many :links, dependent: :destroy, as: :linkable

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  
  validates :body, presence: true

  default_scope { order(best: :desc) }

  def make_best
    transaction do
    	question.answers.update_all(best: false)
    	update!(best: true)
      question.reward&.update!(user: user)
    end
  end
end
