class LinksController < ApplicationController
  before_action :authenticate_user!
  respond_to :html

  def index
    params[:page] = 1 unless params[:page].present?
    @links = Link.where(user_id: current_user.id).order(created_at: :desc).offset((params[:page].to_i-1) * 30).limit(30)
    respond_with(@links)
  end
end
