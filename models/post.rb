class Post < ActiveRecord::Base
  belongs_to :sck_device

  def no2_ppm
    self.no2 / 10
  end

  def co_ppm
    self.co / 75
  end
end
