require 'rails_helper'

# spec/controllers/api/links_controller_spec
RSpec.describe Api::LinksController, type: :controller do

  let(:user) { FactoryBot.create(:user) }
  let(:disabled_user) { FactoryBot.create(:disabled_user) }
  let(:unauthorized_message) { 'Unauthorized - Check your credentials' }
  let(:link) { FactoryBot.create(:link) }

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
        body_items = JSON.parse(response.body).first
        expect(body_items.symbolize_keys.keys).to eq(collection_keys)
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

  describe 'GET #show' do
    context 'with user not logged in app' do
      it 'return error Unauthorized - Check your credentials' do
        get :show, params: { id: link.id }
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'with user profile is disabled and try a request show' do
      it 'return error Unauthorized - Check your credentials' do
        header_auth(disabled_user.key, disabled_user.pwd)
        sign_in disabled_user
        get :show, params: { id: link.id }
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'diferent user try access to links' do
      it 'response body returned has a null string' do
        header_auth(user.key, user.pwd)
        sign_in user
        get :show, params: { id: link.id }
        expect(response.body).to eq('null')
        expect(response.status).to eq(200)
      end
    end

    context 'with user logged in app and get a link' do
      it 'return object and status request http 200' do
        header_auth(link.user.key, link.user.pwd)
        sign_in link.user
        get :show, params: { id: link.token }
        expect(response.status).to eq(200)
        response_body = JSON.parse(response.body)
        expect(response_body["token"]).to eq(link.token)
      end
    end
  end

  describe 'DELETE #destroy' do
    context 'with user not logged in app' do
      it 'return error Unauthorized - Check your credentials' do
        delete :destroy, params: { id: link.token }
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'disabled user profile' do
      it 'return error Unauthorized - Check your credentials' do
        header_auth(disabled_user.key, disabled_user.pwd)
        sign_in disabled_user
        delete :destroy, params: { id: link.token }
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'with user logged in app' do
      it 'return message deleted and status http 200' do
        header_auth(link.user.key, link.user.pwd)
        sign_in link.user
        delete :destroy, params: { id: link.token }
        response_message = JSON.parse(response.body)
        expect(response_message['msg']).to eq('deleted')
        expect(response.status).to eq(200)
      end
    end

    context 'with user logged in app and empty link table' do
      it 'return message link not found and status 404' do
        header_auth(user.key, user.pwd)
        sign_in user
        delete :destroy, params: { id: 'anyinvalidtoken' }
        response_message = JSON.parse(response.body)
        expect(response_message['msg']).to eq('link not found')
        expect(response.status).to eq(404)
      end
    end
  end

  describe '#PATCH update' do
    context 'with user not logged in' do
      it 'return error Unauthorized - Check your credentials' do
        patch :update, params: { id: link.token, original_url: 'http://newlinkurltoredirect.com' }
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'with user trying to log with disabled profile account' do
      it 'return error Unauthorized - Check your credentials' do
        header_auth(disabled_user.key, disabled_user.pwd)
        sign_in disabled_user
        patch :update, params: { id: link.token, original_url: 'http://newlinkurltoredirect.com' }
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'with user logged in' do
      it 'return updated field' do
        header_auth(link.user.key, link.user.pwd)
        sign_in link.user
        new_link = 'http://newlinkurltoredirect.com'
        patch :update, params: { id: link.token, original_url: new_link }
        updated_link = JSON.parse(response.body)
        expect(updated_link["original_url"]).to eq(new_link)
        expect(response.status).to eq(200)
      end
    end
  end
end
