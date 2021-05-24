class QuestionSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers
  
  attributes %i[id title body user_id created_at updated_at files]

  has_many :comments
  has_many :links

  def files
    object.files.map do |file|
      rails_blob_url(file, only_path: true)
    end
  end
end
