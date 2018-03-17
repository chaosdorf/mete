module UsersHelper
  
  # see also: /config/initializers/gravatar_image_tag.rb
  
  def gravatar(user)
    gravatar_image_tag user.email, class: user.active? ? "" : "disabled"
  end

  def redirect_path(user)
    return users_path + '/#' + user.initial
  end
end
