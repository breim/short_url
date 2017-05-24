class LinksController < ApplicationController
  before_action :authenticate_user!, only: :index
  before_action :create_tracking, only: :show

  respond_to :html

  def index
    params[:page] = 1 unless params[:page].present?
    @links = Link.where(user_id: current_user.id).order(created_at: :desc).offset((params[:page].to_i-1) * 40).limit(40)
    respond_with(@links)
  end

  def show
    unless @link.nil?; redirect_to @link.original_url; else render html: nil, status: :ok; end
  end

private
  def create_tracking
    @link = Link.find_by(token: params[:token])
    Tracking.create(link_id: @link.try(:id), referer: request.referrer, browser: request.user_agent, ip: request.remote_ip, ip_data: Tracking.get_ip_data(request.remote_ip))
  end
  
end