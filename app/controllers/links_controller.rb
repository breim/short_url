# app/controllers/links_controllers
class LinksController < ApplicationController
  before_action :authenticate_user!, :fill_page, only: %i(index)
  before_action :authenticate_user!, only: %i(create)
  before_action :create_tracking, only: :show

  respond_to :html

  def index
    @links = Link.where(user_id: current_user.id)
                 .order(created_at: :desc).offset((params[:page].to_i - 1) * 40)
                 .limit(40)
    respond_with(@links)
  end

  def create
    @link = Link.new(link_params)
    @link.user_id = current_user.id
    if @link.save
      redirect_to links_path
    else
      render :new
    end
  end

  def show
    redirect_to @link.original_url && return unless @link.nil?
    render html: nil, status: :ok if @link.nil?
  end

  private

  def link_params
    params.require(:link).permit(:original_url)
  end

  def fill_page
    params[:page] = 1 unless params[:page].present?
  end

  def create_tracking
    @link = Link.find_by(token: params[:token])
    Tracking.create(link_id: @link.try(:id), referer: request.referrer,
                    browser: request.user_agent, ip: request.remote_ip,
                    ip_data: Tracking.get_ip_data(request.remote_ip))
  end
end
