# (c) 2014 Blue Ridge Foundation New York, author: Paul Barnes-Hoggett
# This code is licensed under MIT license (see LICENSE.txt for details)
class ApiKeys

  # @@google_maps

  # cattr_accessor :google_maps, instance_accessor: false
  def self.google_maps
    ENV['GOOGLE_MAPS_KEY']
  end

end