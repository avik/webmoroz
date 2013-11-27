module ApplicationHelper

  def title(page_title, options={})
    content_for(:title, page_title.to_s)
    return content_tag(:h1, page_title, options)
  end

  def after_sign_up_path_for(resource)
     "http://google.com"
#    request.env['omniauth.origin'] || stored_location_for(resource) || edit_user_registration_path
  end

  def after_sign_in_path_for(resource)
     "http://ya.ru"
#    request.env['omniauth.origin'] || stored_location_for(resource) || edit_user_registration_path
  end

  def user_admin
    return current_user.admin
  end

end
