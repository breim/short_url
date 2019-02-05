# app/controllers/links_controllers
class LinksController < ApplicationController
  before_action :authenticate_user!, only: %i[index create new]
  before_action :fill_page, only: :index
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
    send('redirect_link_' + @link.present?.to_s)
  end

  private

  def redirect_link_true
    redirect_to @link.original_url
  end

  def redirect_link_false
    render html: nil, status: :ok
  end

  def link_params
    params.require(:link).permit(:original_url)
  end

  def fill_page
    params[:page] = 1 unless params[:page].present?
  end

  def create_tracking
    @link = Link.find_by(token: params[:token])
    Tracking.create_tracking(@link, request)
  end
end
