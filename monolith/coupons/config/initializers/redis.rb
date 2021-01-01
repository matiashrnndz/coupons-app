redis_opts = YAML.safe_load(ERB.new(File.read("#{Rails.root}/config/redis.yml")).result)[Rails.env].symbolize_keys!

Sidekiq.configure_server do |config|
  config.redis = redis_opts
end

Sidekiq.configure_client do |config|
  config.redis = redis_opts
end
