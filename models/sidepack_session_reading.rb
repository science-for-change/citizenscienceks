class SidepackSessionReading < ActiveRecord::Base
  belongs_to :sidepack_session
  validates :sidepack_session, presence: true, associated: true
  validates :reading_timestamp, presence: true
  validates :reading, presence: true

  def calibrated_reading
    reading * 0.6
  end
end
