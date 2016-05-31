module UsersHelper
  def gravatar(user)
    if user.respond_to? :email
      gravatar_image_tag user.email, :gravatar => { :default => 'https://assets.github.com/images/gravatars/gravatar-140.png' }, class: user.active? ? "" : "disabled"
    else
      gravatar_image_tag class: user.active? ? "" : "disabled"
    end
  end
end
