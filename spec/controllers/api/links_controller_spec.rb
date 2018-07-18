require 'rails_helper'

# spec/controllers/api/links_controller_spec
RSpec.describe Api::LinksController, type: :controller do

  let(:user) { FactoryBot.create(:user) }
  let(:disabled_user) { FactoryBot.create(:disabled_user) }
  let(:link) { FactoryBot.create(:link) }
  let(:unauthorized_message) { 'Unauthorized - Check your credentials' }

  describe 'GET #index on Api Methods' do
    context 'with user not logged' do
      it 'return Unauthorized - Check your credentials error' do
        get :index
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'user logged in app but disabled profile' do
      it 'return error Unauthorized - Check your credentials' do
        header_auth(disabled_user.key, disabled_user.pwd)
        sign_in disabled_user
        get :index
        expect(response.body).to eq(unauthorized_message)
      end
    end

    context 'user logged in app and valid user and empty links' do
      it 'return a json empty collection array and status 200' do
        header_auth(user.key, user.pwd)
        sign_in user
        get :index
        expect(response.status).to eq(200)
        expect(response.body).to eq("[]")
      end
    end

    context 'user logged in app and valid user and empty links' do

      it 'check all keys from a success request to links' do
        collection_keys = %w(id original_url short_url token created_at).map(&:to_sym).freeze
        header_auth(link.user.key, link.user.pwd)
        sign_in link.user
        get :index
        expect(JSON.parse(response.body).first.symbolize_keys.keys).to eq(collection_keys)
        expect(response.status).to eq(200)
      end


      it 'return link json collection(size 11) with status 200' do
        header_auth(link.user.key, link.user.pwd)
        sign_in link.user
        10.times { link.dup.save }
        get :index
        expect(link.user.links.count).to eq(11)
        expect(response.status).to eq(200)
      end

    end
  end
end
