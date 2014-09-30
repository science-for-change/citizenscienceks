require 'httparty'

class SmartCitizenClient
  include HTTParty

  def initialize api_key, device_id
    @base_url = "http://api.smartcitizen.me/v0.0.1/"+api_key+"/"+device_id
  end

  def get_latest_post
    endpoint = @base_url+"/posts.json"
    return self.class.get(endpoint)
  end

  def get_posts_for_date date
    next_date = date+1
    endpoint = @base_url+"/posts.json?from_date=#{date.year}-#{date.month}-#{date.day}&to_date=#{next_date.year}-#{next_date.month}-#{next_date.day}"
    return self.class.get(endpoint)
  end

end
