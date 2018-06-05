class Api::TrackingsController < Api::ApiController
  def show
    @link = Link.find_by_token(params[:id])
    @tracking = Tracking.find_by_link_id(@link.id)
    @objs = {}
    @objs << @link
    @objs << @tracking

    render json: @objs
  end

end
