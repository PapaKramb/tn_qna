class Question < ApplicationRecord
  has_many :answers, dependent: :destroy
  belongs_to :user
  
  validates :title, :body, presence: true

  def one_best_answer
    answers.where(best: true).first
  end
end
