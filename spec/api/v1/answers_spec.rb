require 'rails_helper'

describe 'Questions API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions/:id/answers' do
    let(:question) { create(:question, user: create(:user)) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:answers) { create_list(:answer, 2, user: user, question: question) }
      let(:answer) { answers.first }
      let(:answer_response) { json['answers'].first }

      before { get api_path, params: { access_token: access_token.token } , headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of answers' do
        expect(json['answers'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id body created_at updated_at].each do |attr|
          expect(answer_response[attr]).to eq answer.send(attr).as_json
        end
      end
    end
  end

  describe 'GET /api/v1/answer/:id/' do
    let(:question) { create(:question, user: create(:user)) }
    let(:answer) { create(:answer, user: create(:user), question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:comments) { create_list(:comment, 2, user: user, commentable: answer) }

      before do
        answer.links.build(name: "name", url: "https://github.com/PapaKramb/tn_qna").save
        answer.save
        get api_path, params: { access_token: access_token.token } , headers: headers
      end

      let(:answer_response) { json['answer'] }
      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of comments' do
        expect(answer_response['comments'].size).to eq 2
      end

      it 'returns list of links' do
        expect(answer_response['links'].size).to eq 1
      end
    end
  end

  describe 'POST /api/v1/questions/:question_id/answers' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:question) { create(:question, user: create(:user)) }
    let(:api_path) { "/api/v1/questions/#{question.id}/answers" }
    let(:method) { :post }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:body) { 'body' }
      let(:title) { 'title' }
      let(:links_attributes) { { 0 => {name: "link", url: "https://github.com/PapaKramb/tn_qna"} } }

      before do
        post api_path, params: {access_token: access_token.token,
                                answer: { body: body,title: title, links_attributes: links_attributes}
                               }, headers: headers
      end

      let(:answer_response) { json['answer'] }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer body' do
        expect(answer_response['body']).to eq body
      end

      it 'returns list of links' do
        expect(answer_response['links'].size).to eq 1
        expect(answer_response['links'].first['name']).to eq 'link'
        expect(answer_response['links'].first['url']).to eq "https://github.com/PapaKramb/tn_qna"
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let!(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :delete }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        delete api_path, params: {access_token: access_token.token, id: answer.id }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'changes questions count by -1' do
        expect(Answer.count).to eq 0
      end
    end
  end

  describe 'PATCH /api/v1/answers/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, user: user, question: question) }
    let(:api_path) { "/api/v1/answers/#{answer.id}" }
    let(:method) { :put }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:body) { 'body' }
      let(:title) { 'title' }
      let(:question_response) { json['answer'] }
      before do
        put api_path, params: { access_token: access_token.token, answer: { body: body, title: title}}, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns answer new body' do
        expect(question_response['body']).to eq body
      end
    end
  end
end