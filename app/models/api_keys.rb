class ApiKeys

  # @@google_maps

  # cattr_accessor :google_maps, instance_accessor: false
  def self.google_maps
    ENV['GOOGLE_MAPS_KEY']
  end

end