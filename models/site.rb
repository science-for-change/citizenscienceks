class Site < ActiveRecord::Base
  has_many :ghost_wipes
  has_many :diffusion_tubes
  has_many :sck_devices
end
