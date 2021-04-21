class Reward < ApplicationRecord
  has_one :user_reward, dependent: :destroy
  has_one :user, through: :user_reward
  belongs_to :question

  validates :title, :image_url, presence: true
  validates :image_url, format: { with: URI::regexp }
end
