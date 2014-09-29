require 'httparty'

class SmartCitizenClient
  include HTTParty

  def self.get_latest_post api_key, device_id
    endpoint = "http://api.smartcitizen.me/v0.0.1/"+api_key+"/"+device_id+"/posts.json"
    return self.get(endpoint)
  end

end
