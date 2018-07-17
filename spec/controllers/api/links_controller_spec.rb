require 'rails_helper'

RSpec.describe Api::LinksController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:disabled_user) { FactoryBot.create(:disabled_user) }

  describe 'GET #index on Api Methods' do
    context 'with user not logged' do
      it 'return Unauthorized - Check your credentials error' do
        unauthorized_message = 'Unauthorized - Check your credentials'
        get :index
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'user logged in app but disabled profile' do
    end

    context 'user logged in app and valid user' do
    end
  end
end