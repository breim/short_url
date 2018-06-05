class Api::TrackingsController < Api::ApiController
  def show
    @link = Link.find_by_token(params[:id])
    @tracking = Tracking.where(link_id: @link.id)
    render json: [@link, @tracking]
  end
end
