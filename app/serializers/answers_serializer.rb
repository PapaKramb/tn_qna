class AnswersSerializer < ActiveModel::Serializer
  attributes %i[id user_id question_id body created_at updated_at]
end
