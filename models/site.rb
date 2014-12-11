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
        description: location,
        has_diffusion_tubes: has_diffusion_tubes,
        has_ghost_wipes: has_ghost_wipes,
        has_sck_devices: has_sck_devices,
        site_id: id
      }
    }
  end

  def has_diffusion_tubes
    diffusion_tubes.size > 0
  end

  def has_ghost_wipes
    ghost_wipes.size > 0
  end

  def has_sck_devices
    sck_devices.size > 0
  end
end
