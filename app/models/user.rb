class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :user_rewards, dependent: :destroy
  has_many :rewards, through: :user_rewards
  has_many :votes, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :subscribes, dependent: :destroy

  def author?(resource)
    resource.user_id == id
  end

  def subscriber_of?(question)
    question.subscribes.find_by(user_id: id).present?
  end
end
