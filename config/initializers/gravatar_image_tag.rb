# used only in /app/helpers/users_helper.rb

# see https://github.com/mdeering/gravatar_image_tag

GravatarImageTag.configure do |config|
  config.default_image = "https://assets.github.com/images/gravatars/gravatar-140.png"
  config.secure = true
end