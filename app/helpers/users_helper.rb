module UsersHelper
  
  # see also: /config/initializers/gravatar_image_tag.rb
  
  def avatar(user)
    case user.avatar_provider
    when "gravatar"
      gravatar_image_tag user.avatar, class: user.active? ? "" : "disabled"
    when "webfinger"
      webfinger_activitypub_image_tag user.avatar
    end
  end

  def redirect_path(user)
    return users_path + '/#' + user.initial
  end

  private

  def fetch(request, redirect_limit = 10)
    raise "Exceeded HTTP redirect limit" if redirect_limit <= 0

    http = Net::HTTP::new(request.uri.host, request.uri.port)
    http.open_timeout = 3
    http.read_timeout = 3
    http.ssl_timeout = 3
    http.use_ssl = request.uri.scheme == 'https'
    response = http.start do |http|
      request
      response = http.request request
    end

    case response
    when Net::HTTPSuccess
      response
    when Net::HTTPRedirection
      # FIXME: Support other non GET HTTP methods
      redirected_request = Net::HTTP::Get.new URI::parse(response["location"])

      fetch(redirected_request, redirect_limit - 1)
    else
      response.error!
    end
  end

  # This function implements a best effort approach to getting fetching the avatar.
  # Based on an activity+json endpoint returned by WebFinger it directly fetches
  # the avatar url from the server hosting the account.
  # Note that as we just make unauthenticated requests to random fediverse servers
  # there's a good chance that this will fail, as many servers require authenticated
  # or signed requests.
  # For a more consistent experience mete can use the mastodon client api with a bot account,
  # see the function below.
  def fetch_avatar_url_from_activitypub_server(activity_json_url)
    activity_json_request = Net::HTTP::Get.new URI::parse(activity_json_url)
    activity_json_request["Accept"] = "application/activity+json"

    activity_json_response = fetch activity_json_request

    JSON.parse(activity_json_response.body)["icon"]["url"]
  end

  # This function asks a configured mastodon server for a resolved WebFinger subject.
  # This is much more reliable than directly fetching from the subject's activity+json
  # endpoint as requests will be properly authenticated and signed by the configured mastodon
  # server.
  # Note that requests may be subject to moderation, the server the subject is on might have
  # blocked the configured server.
  # Also note that the avatar url returned by this api call is subject to the caching rules
  # of the configured mastodon server. In most cases this means that mete will request the media
  # cache of the configured mastodon server instead of the subject's server.
  def fetch_avatar_url_using_mastodon_client(subject)
    server_url = URI::parse(Mete::Application.config.avatar_mastodon_client_url)
    server_url.path = "/api/v1/accounts/search"
    server_url.query = URI.encode_www_form({ :q => subject.delete_prefix("acct:"), :resolve => true })

    account_search_request = Net::HTTP::Get.new server_url
    account_search_request["Authorization"] = "Bearer #{Mete::Application.config.avatar_mastodon_client_token}"

    account_search_response = fetch account_search_request

    JSON.parse(account_search_response.body).first["avatar"]
  end

  def fetch_avatar_url_from_webfinger_or_activitypub(identifier)
    # NOTE: acct URIs as defined in RFC 7565 (https://datatracker.ietf.org/doc/html/rfc7565#section-7)
    #       do not support inputs without an @ delimiter.
    #       We specifically ignore this to support a $identifier -> https://$identifier/.well-known/webfinger
    #       lookup (without a resource query, also violating RFC 7033 while we're at it).
    #       This is to support the common use case of hosting the webfinger path as a static file
    #       without any query string handling on a personal domain.
    #       See https://nwex.dev/.well-known/webfinger
    #       See https://gnom.is/.well-known/webfinger
    host = identifier.include?("@") ? identifier.split("@").last : identifier

    # RFC 7033 4.2. Performing a WebFinger Query (https://datatracker.ietf.org/doc/html/rfc7033#section-4.2)
    #               [...] A client MUST query the WebFinger resource using HTTPS only. [...]
    webfinger_url = URI::HTTPS.build(host: host, path: "/.well-known/webfinger")

    # See the note above
    if host != identifier
      webfinger_url.query = URI.encode_www_form({ :resource => "acct:#{identifier.delete_prefix("@")}" })
    end

    webfinger_response = JSON.parse(fetch(Net::HTTP::Get.new(webfinger_url)).body)

    # NOTE: This is a standard relation that nobody seems to implement, certainly fediverse platforms
    #       aren't serving this.
    webfinger_avatar_relation = webfinger_response["links"].select { |entry| entry["rel"] == "http://webfinger.net/rel/avatar" }.first
    activity_json_relation = webfinger_response["links"].select { |entry| entry["type"] == "application/activity+json" }.first

    if webfinger_avatar_relation
      webfinger_avatar_relation["href"]
    elsif Mete::Application.config.avatar_mastodon_client_token
      fetch_avatar_url_using_mastodon_client webfinger_response["subject"]
    else
      fetch_avatar_url_from_activitypub_server activity_json_relation["href"]
    end
  rescue
    nil
  end

  def webfinger_activitypub_image_tag(identifier)
    avatar_url = Rails.cache.fetch("fetch_avatar_url_from_webfinger_or_activitypub #{identifier}", expires_in: 1.day) do
      fetch_avatar_url_from_webfinger_or_activitypub identifier
    end

    if not avatar_url
      return tag "img", class: [ "webfinger-missing" ]
    end

    options = {}
    options[:src] = avatar_url
    options[:alt] ||= 'Profile picture'
    options[:height] = options[:width] = 80
    tag "img", options, false, false
  end
end
