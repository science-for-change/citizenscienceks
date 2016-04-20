class SidepackSession < ActiveRecord::Base
  has_many :readings, class_name: "SidepackSessionReading"
end
