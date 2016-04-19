require 'open-uri'

class ProcessSidepackFile
  include Sidekiq::Worker

  def perform(upload_id)
    if upload = Upload.where(id: upload_id).take
      raw = open(upload.file.url).read
      binding.pry
    end
  end
end
