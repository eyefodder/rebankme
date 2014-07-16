Geocoder.configure(
  #ENV['QUOTAGUARD_URL'] only set on heroku, and not stored in source. When nil, no proxy will be used
  :http_proxy => ENV['QUOTAGUARD_URL'],
  :timeout => 5

)
# Geocoder::Configuration.lookup = :geocoder_ca
# Geocoder::Configuration.cache = Redis.new