module UsersHelper
  
  # see also: /config/initializers/gravatar_image_tag.rb
  
  def avatar(user)
    case user.avatar_provider
    when 'gravatar'
      gravatar_image_tag user.avatar, class: user.active? ? '' : 'disabled'
    when 'webfinger'
      webfinger_activitypub_image_tag user.avatar
    end
  end

  def redirect_path(user)
    return users_path + '/#' + user.initial
  end

  private

  def http_client
    Faraday.new Mete::Application.config.avatar_mastodon_client_url do |faraday|
      faraday.headers[:user_agent] = "Metekasse (#{Faraday::Connection::USER_AGENT})"
      faraday.response :json
      faraday.response :follow_redirects
      faraday.adapter Faraday.default_adapter
    end
  end

  # NOTE: This function attempts to retrieve an avatar url by directly
  #       talking ActivityPub to an endpoint discovered by Webfinger.
  #       This will fail in case servers require signed requests.
  def fetch_avatar_url_from_activitypub_server(activity_json_url)
    activity_json_response = http_client.get(activity_json_url) do |request|
      request.headers[:accept] = 'application/activity+json'
    end

    Rails.logger.debug "Using activity+json '#{activity_json_url}' fetched directly, resolving to '#{activity_json_response.body.dig('icon', 'url')}'"

    activity_json_response.body.dig('icon', 'url')
  end

  # NOTE: This function attempts to retrieve an avatar url by talking to a Mastodon
  #       server and looking up an account. This request will optionally include
  #       authentication against the Mastodon API.
  def fetch_avatar_url_using_mastodon_client(subject)
    http_client.url_prefix = Mete::Application.config.avatar_mastodon_client_url

    mastodon_response = http_client.get('/api/v1/accounts/lookup') do |request|
      request.params[:acct] = subject.delete_prefix('acct:')
      request.headers[:authorization] = "Bearer #{Mete::Application.config.avatar_mastodon_client_token}"
    end

    Rails.logger.debug "Using subject '#{subject}' fetched via Mastodon API on #{Mete::Application.config.avatar_mastodon_client_url}, resolving to '#{mastodon_response.body.dig('avatar')}'"

    mastodon_response.body.dig('avatar')
  end

  def fetch_avatar_url_from_webfinger_or_activitypub(identifier)
    # NOTE: The WebFinger gem supports identifiers like "gnom.is" without a "user@",
    #       allowing the somewhat common practice of serving a static webfinger file.
    #       It does however not support something like "@ordnung@chaos.social", only
    #       "ordnung@chaos.social", as such we trim an initial "@" here.
    webfinger_response = WebFinger.discover! identifier.delete_prefix('@') rescue return

    return unless webfinger_response.is_a? Hash

    webfinger_subject = webfinger_response[:subject]
    webfinger_links = webfinger_response[:links]

    return unless webfinger_subject.is_a? String
    return unless webfinger_links.is_a? Enumerable

    # NOTE: This is a standard relation that not much fediverse software seems to implement currently.
    #       Since first working on this Mete feature, Mastodon 4.2.0 and newer now have support!
    webfinger_avatar_relation = webfinger_links.find do |entry|
      entry.is_a?(Hash) &&
        entry[:rel] == 'http://webfinger.net/rel/avatar' &&
        entry[:href].is_a?(String)
    end

    activity_json_relation = webfinger_links.find do |entry|
      entry.is_a?(Hash) &&
        entry[:rel] == 'self' &&
        entry[:type] == 'application/activity+json' &&
        entry[:href].is_a?(String)
    end

    Rails.logger.debug "Resolved identifier '#{identifier}' with webfinger to subject '#{webfinger_subject}', avatar relation '#{webfinger_avatar_relation&.fetch(:href)}' and self activity+json relation '#{activity_json_relation&.fetch(:href)}'"

    if webfinger_avatar_relation
      Rails.logger.debug "Using http://webfinger.net/rel/avatar '#{webfinger_avatar_relation[:href]}'"
      webfinger_avatar_relation[:href]
    elsif Mete::Application.config.avatar_mastodon_client_url
      fetch_avatar_url_using_mastodon_client webfinger_subject rescue return
    else
      fetch_avatar_url_from_activitypub_server activity_json_relation[:href] rescue return
    end
  end

  def webfinger_activitypub_image_tag(identifier)
    avatar_url = Rails.cache.fetch("fetch_avatar_url_from_webfinger_or_activitypub #{identifier}", expires_in: 1.day) do
      fetch_avatar_url_from_webfinger_or_activitypub identifier
    end

    if not avatar_url
      return tag 'img', class: [ 'webfinger-missing' ]
    end

    options = {}
    options[:src] = avatar_url
    options[:alt] = "Profile picture for #{identifier}"
    options[:height] = options[:width] = 80
    tag 'img', options, false, false
  end
end
