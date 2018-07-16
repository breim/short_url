# app/controllers/reports_controller.rb
class ReportsController < ApplicationController
  before_action :authenticate_user!

  respond_to :html

  # include the report generator in excel
  include ExcelReport

  def create
    @links = Link.all
    create_report(params[:filter])
  end
end
