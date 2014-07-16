Geocoder.configure(
  #ENV['QUOTAGUARD_URL'] only set on heroku, and not stored in source. When nil, no proxy will be used
  :http_proxy => ENV['QUOTAGUARD_URL'],
  :timeout => 5

)

# for if connection is crap
# Geocoder.configure(:lookup => :test)
# Geocoder::Lookup::Test.set_default_stub([])
# Geocoder::Lookup::Test.add_stub(
#         '11205', [
#           {
#             'latitude'     => 40.6945036,
#             'longitude'    => -73.9565551,
#             'country_code' => 'US'
#           }
#         ]
#         )

# Geocoder::Configuration.lookup = :geocoder_ca
# Geocoder::Configuration.cache = Redis.new