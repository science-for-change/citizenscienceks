class Site < ActiveRecord::Base
  has_many :ghost_wipes
  has_many :diffusion_tubes
  has_many :sck_devices

  def as_json(options)
    {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [longitude,latitude]
      },
      properties: {
        title: name,
        description: location
      }
    }
  end
end
