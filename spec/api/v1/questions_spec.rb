require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:user) { create(:user) }
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }

  describe 'GET /api/v1/questions' do
    let(:api_path) { '/api/v1/questions' }
    
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorize' do
      let(:access_token) { create(:access_token) }
      let!(:questions) { create_list(:question, 2, user: user) }
      let(:question) { questions.first }
      let(:question_responce) { json['questions'].first }
      let!(:answers) { create_list(:answer, 3, question: question, user: user) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of questions' do
        expect(json['questions'].size).to eq 2
      end

      it 'returns all public fields' do
        %w[id title body created_at updated_at].each do |attr|
          expect(question_responce[attr]).to eq question.send(attr).as_json
        end
      end

      it 'contains user object' do
        expect(question_responce['user']['id']).to eq question.user.id
      end

      it 'contains short title' do
        expect(question_responce['short_title']).to eq question.title.truncate(7)
      end

      describe 'Answers' do
        let(:answer) { answers.first }
        let(:answer_responce) { question_responce['answers'].first }

        it 'returns list of answers' do
          expect(question_responce['answers'].size).to eq 3
        end

        it 'returns all public fields' do
          %w[id body user_id created_at updated_at].each do |attr|
            expect(answer_responce[attr]).to eq answer.send(attr).as_json
          end
        end
      end
    end
  end

  describe 'GET /api/v1/questions/:id/' do
    let(:question) { create(:question, user: create(:user)) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:comments) { create_list(:comment, 2, user: user, commentable: question) }

      before do
        question.links.build(name: "name", url: "https://github.com/PapaKramb/tn_qna").save
        question.save
        get api_path, params: { access_token: access_token.token } , headers: headers
      end

      let(:question_response) { json['question'] }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of comments' do
        expect(question_response['comments'].size).to eq 2
      end

      it 'returns list of links' do
        expect(question_response['links'].size).to eq 1
      end
    end
  end

  describe 'GET /api/v1/questions/:id/' do
    let(:question) { create(:question, user: create(:user)) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :get }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let!(:comments) { create_list(:comment, 2, user: user, commentable: question) }

      before do
        question.links.build(name: "name", url: "https://github.com/PapaKramb/tn_qna").save
        question.save
        get api_path, params: { access_token: access_token.token } , headers: headers
      end

      let(:question_response) { json['question'] }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns list of comments' do
        expect(question_response['comments'].size).to eq 2
      end

      it 'returns list of links' do
        expect(question_response['links'].size).to eq 1
      end
    end
  end

  describe 'POST /api/v1/questions' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:api_path) { "/api/v1/questions" }
    let(:method) { :post }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token) }
      let(:user) { create(:user) }
      let(:title) { 'title' }
      let(:body) { 'body' }
      let(:links_attributes) { { 0 => {name: "link", url: "https://github.com/PapaKramb/tn_qna"} } }

      before do
        post api_path, params: {access_token: access_token.token, question: { title: title, body: body, links_attributes: links_attributes}
                               }, headers: headers
      end

      let(:question_response) { json['question'] }

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question title and body' do
        expect(question_response['title']).to eq title
        expect(question_response['body']).to eq body
      end

      it 'returns list of links' do
        expect(question_response['links'].size).to eq 1
        expect(question_response['links'].first['name']).to eq 'link'
        expect(question_response['links'].first['url']).to eq "https://github.com/PapaKramb/tn_qna"
      end
    end
  end

  describe 'DELETE /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :delete }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }

      before do
        delete api_path, params: { access_token: access_token.token, id: question.id }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'changes questions count by -1' do
        expect(Question.count).to eq 0
      end
    end
  end

  describe 'PATCH /api/v1/questions/:id' do
    let(:headers) { { "ACCEPT" => "application/json" } }
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:api_path) { "/api/v1/questions/#{question.id}" }
    let(:method) { :put }

    it_behaves_like 'API authorizable'

    context 'authorized' do
      let(:access_token) { create(:access_token, resource_owner_id: user.id) }
      let(:title) { 'title' }
      let(:body) { question.body }
      let(:question_response) { json['question'] }
      before do
        put api_path, params: { access_token: access_token.token, question: { title: title } }, headers: headers
      end

      it 'returns 200 status' do
        expect(response).to be_successful
      end

      it 'returns question new title and  old body' do
        expect(question_response['title']).to eq title
        expect(question_response['body']).to eq body
      end
    end
  end
end