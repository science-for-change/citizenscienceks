require 'carrierwave/orm/activerecord'
class Upload < ActiveRecord::Base

  after_save :process_file

  mount_uploader :file, Uploader

  FILE_UPLOAD_LIMIT = 1 # MB

  validates :file, presence: true
  validates :upload_type, presence: true
  validate :file_size

  enum upload_type: {
    sidepack_file: 0,
    kmz_file: 1
  }

  def file_size
    if file && file.size.to_f/(1024*1024) > FILE_UPLOAD_LIMIT
      errors.add(:file, "Uploaded file is too big!")
    end
  end

  def process_file
    #binding.remote_pry
  end
end
