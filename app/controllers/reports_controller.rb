# app/controllers/report_controller.rb
class ReportsController < ApplicationController
  before_action :authenticate_user!

  respond_to :html

  def create
    @links = Link.all
    create_report(params[:filter])
  end

  private

  def get_clicks_by_filter(link, filter)
    Tracking.where("created_at >= ?",  filter.to_i.days.ago).count
  end

  def create_report(filter)
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: 'Report in the last ' + filter) do |sheet|
        sheet.add_row ['Original url', 'Short url', 'Clicks']
        @links.each do |link|
          sheet.add_row [link.original_url, link.short_url, get_clicks_by_filter(link, filter)]
        end
      end
      send_data (p.to_stream.read), type: "application/xlsx", filename: "report.xlsx"
      # p.serialize('report.xlsx')
    end
  end
end