require 'rails_helper'

describe 'Profiles API', type: :request do
  let(:headers) { { "CONTENT_TYPE" => "application/json", "ACCEPT" => "application/json" } }
  let(:me) { create(:user) }
  let(:access_token) { create(:access_token, resource_owner_id: me.id) }

  describe 'GET /api/v1/profiles/me' do
    let(:api_path) { '/api/v1/profiles/me' }
    
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorize' do
      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end
      
      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['user'][attr]).to eq me.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password ecrypted_password].each do |attr|
          expect(json).to_not have_key(attr)
        end
      end
    end
  end
  
  describe 'GET /api/v1/profiles/' do
    let(:api_path) { '/api/v1/profiles/' }
    
    it_behaves_like 'API authorizable' do
      let(:method) { :get }
    end

    context 'authorize' do
      let!(:users) { create_list(:user, 3) }

      before { get api_path, params: { access_token: access_token.token }, headers: headers }

      it 'returns 200 status' do
        expect(response).to be_successful
      end
      
      it 'returns list of others profile' do
        expect(json['users'].size).to eq 3
      end

      it 'returns all public fields' do
        %w[id email admin created_at updated_at].each do |attr|
          expect(json['users'].first[attr]).to eq users.first.send(attr).as_json
        end
      end

      it 'does not returns private fields' do
        %w[password encrypted_password].each do |attr|
          expect(json['users'].first).to_not have_key(attr)
        end
      end
    end
  end
end