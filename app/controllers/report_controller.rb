# app/controllers/report_controller.rb
class ReportController < ApplicationController
  before_action :authenticate_user!

  respond_to :html

  def create; end

end