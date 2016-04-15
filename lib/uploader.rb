class Uploader < CarrierWave::Uploader::Base

  storage :fog
  configure do |config|
    config.fog_credentials = {
      provider:               'AWS',
      aws_access_key_id:      ENV['AWS_ACCESS_KEY_ID'],
      aws_secret_access_key:  ENV['AWS_SECRET_ACCESS_KEY'],
      region:                 'eu-central-1'
    }
    config.fog_public     = true
    config.fog_attributes = {'Cache-Control' => 'max-age=315576000'}
    config.fog_directory  = 'citizenscienceks'
  end

  def cache_dir
    Padrino.root("tmp")
  end

  def extension_white_list
    %w(txt kmz)
  end

  def filename
    "#{original_filename}"
  end
end
