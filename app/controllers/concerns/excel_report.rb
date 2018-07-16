# Excel report about all links and the quantity of clicks
module ExcelReport
  def get_clicks_by_filter(link_id, filter)
    Tracking.where('link_id = ? AND created_at >= ?', link_id, filter.to_i.days.ago).count
  end

  def create_report(filter)
    Axlsx::Package.new do |p|
      p.workbook.add_worksheet(name: 'Report in the last ' + filter) do |sheet|
        sheet.add_row ['Original url', 'Short url', 'Clicks']
        @links.each do |link|
          sheet.add_row [link.original_url, link.short_url, get_clicks_by_filter(link.id, filter)]
        end
      end
      send_data p.to_stream.read, type: 'application/xlsx', filename: 'report.xlsx'
    end
  end
end
