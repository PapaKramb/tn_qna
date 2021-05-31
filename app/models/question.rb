class Question < ApplicationRecord
  include Votable
  include Commentable
  
  has_one :reward, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :links, dependent: :destroy, as: :linkable
  belongs_to :user
  has_many :subscribes, dependent: :destroy
  has_many :subscribers, through: :subscribes

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank
  accepts_nested_attributes_for :reward, reject_if: :all_blank
  
  validates :title, :body, presence: true

  after_create :calculate_reputation

  scope :today, -> { where("DATE(created_at) = ? ", Date.today) }

  private

  def calculate_reputation
    ReputationJob.perform_later(self)
  end
end
