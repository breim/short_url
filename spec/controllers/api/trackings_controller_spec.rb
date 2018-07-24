require 'rails_helper'

# spec/controllers/api/trackings_controller_spec
RSpec.describe Api::TrackingsController, type: :controller do
  let(:user) { FactoryBot.create(:user) }
  let(:disabled_user) { FactoryBot.create(:disabled_user) }
  let(:unauthorized_message) { 'Unauthorized - Check your credentials' }
  let(:link) { FactoryBot.create(:link) }
  let(:tracking_params) { FactoryBot.create(:tracking)  }

  describe 'GET #show on API methodss' do
    context 'with user not logged in app' do
      it 'return Unauthorized - Check your credentials error' do
        get :show, params: { id: link.token }
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'user trying to request trackings with disable profile' do
      it 'return Unauthorized - Check your credentials error' do
        header_auth(disabled_user.key, disabled_user.pwd)
        sign_in disabled_user
        get :show, params: { id: link.token }
        expect(response.body).to eq(unauthorized_message)
        expect(response.status).to eq(401)
      end
    end

    context 'user loggend in app creating a track to your link' do
      it 'see tracking of a expecific link returned' do
        header_auth(link.user.key, link.user.pwd)
        sign_in link.user
        expect(link.trackings.count).to eq(0)
        Tracking.create_tracking(link, tracking_params)
        get :show, params: { id: link.token }
        res = JSON.parse(response.body)
        expect(res[0]["tracking"]).not_to be_empty
        expect(res[0]["link"]["id"]).to equal(link.id)
        expect(response.status).to equal(200)
        expect(link.trackings.count).to eq(1)
      end
    end
  end
end