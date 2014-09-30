require 'httparty'
require 'uri'

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

    # cludge: need to make four calls per day to ensure
    # smartcitizen.me API does not hit its max limit of
    # 500 posts per response

    posts = []
    [
    DateTime.new(date.year, date.month, date.day),
    DateTime.new(date.year, date.month, date.day, 6),
    DateTime.new(date.year, date.month, date.day, 12),
    DateTime.new(date.year, date.month, date.day, 18)].each do | datetime |

      if six_hour_posts = get_posts_for_six_hours(datetime)
        posts << six_hour_posts
      end
    end

    return posts.flatten
  end

  private
  def get_posts_for_six_hours datetime
    endpoint = @base_url+"/posts.json?from_date=#{datetime.year}-#{datetime.month}-#{datetime.day} #{datetime.hour}:00:00&to_date=#{datetime.year}-#{datetime.month}-#{datetime.day} #{datetime.hour+5}:59:59"
    if posts = self.class.get(URI.escape(endpoint))['device']['posts']
      return posts.size > 0 ? posts : nil
    else
      nil
    end
  end
end
