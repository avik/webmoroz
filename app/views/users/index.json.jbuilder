json.array!(@users) do |user|
  json.extract! user, :username, :nickname, :provider, :url
  json.url user_url(user, format: :json)
end
