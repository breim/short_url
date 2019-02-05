# app/helpers/application_helper
module ApplicationHelper
  def link_create_account
    "<li>#{link_to 'Create account', new_user_registration_path}</li>".html_safe unless current_user
  end
end
