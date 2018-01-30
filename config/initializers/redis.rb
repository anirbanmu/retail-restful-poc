$redis_raw = Redis.new
$redis = Redis::Namespace.new("#{Rails.application.class.parent_name}:#{Rails.env}".to_sym, :redis => $redis_raw)

$redis_raw.select(0) if Rails.env == 'production'
$redis_raw.select(1) if Rails.env == 'development'
$redis_raw.select(2) if Rails.env == 'test'

# Clear out db if not production
if Rails.env == 'development' || Rails.env == 'test'
  $redis_raw.flushdb
end
