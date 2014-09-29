class SckDevice < ActiveRecord::Base
  before_save :get_attributes
  has_many :posts


  private

  def get_attributes

    # get latest post to get created timestamp
    if post = SmartCitizenClient.get_latest_post(self.SCK_API_key, self.SCK_id)

      # dave data
      if d = post['device']

        self.title = d['title'] || nil
        self.description = d['description'] || nil
        self.location = d['location'] || nil
        self.city = d['city'] || nil
        self.country = d['country'] || nil
        self.exposure = d['exposure'] || nil
        self.elevation = d['elevation'] || nil
        self.geo_lat = d['geo_lat'] || nil
        self.geo_long = d['geo_long'] || nil
        self.created = d['created'] || nil
        self.last_insert_datetime = d['last_insert_datetime'] || nil

      end
    end

  end

  def get_all_posts

    # get latest post to get created timestamp
    post = SmartCitizenClient.get_latest_post self.SCK_API_key, self.SCK_id

  end

end
