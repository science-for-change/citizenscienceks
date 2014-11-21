class SckDevice < ActiveRecord::Base
  before_save :get_attributes
  belongs_to :site
  has_many :posts

  def average_no2(**args)
    date_from = args[:date_from] || nil
    date_to = args[:date_to] || nil
    ppm = args[:ppm] || nil
    posts = if date_from && date_to
              self.posts.where(:timestamp => date_from.beginning_of_day...date_to.end_of_day).where("no2 > 0.01").select(:no2)
            else
              self.posts.where("no2 > 0.01").select(:no2)
            end
    if ppm
      posts.map(&:no2_ppm).sum / posts.size.to_f
    else
      posts.map(&:no2).sum / posts.size.to_f
    end
  end

  def average_co(**args)
    date_from = args[:date_from] || nil
    date_to = args[:date_to] || nil
    ppm = args[:ppm] || nil
    posts = if date_from && date_to
              self.posts.where(:timestamp => date_from.beginning_of_day...date_to.end_of_day).where("co > 0.01").select(:co)
            else
              self.posts.where("co > 0.01").select(:co)
            end
    if ppm
      posts.map(&:co_ppm).sum / posts.size.to_f
    else
      posts.map(&:co).sum / posts.size.to_f
    end
  end

  def as_json(options)
    {
      type: "Feature",
      geometry: {
        type: "Point",
        coordinates: [geo_long.to_f,geo_lat.to_f]
      },
      properties: {
        title: title,
        description: description,
        location: location,
        city: city,
        country: country,
        exposure: exposure,
        elevation: elevation,
        created: created,
        last_insert_datetime: last_insert_datetime
      }
    }
  end

  def get_attributes

    # initialize client
    client = SmartCitizenClient.new self.SCK_API_key, self.SCK_id

    # get latest post to get created timestamp
    if post = client.get_latest_post

      # save data
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

    # initialize client
    client = SmartCitizenClient.new self.SCK_API_key, self.SCK_id

    # get latest post to get created timestamp
    if latest_post = client.get_latest_post

      # save all posts if any found
      installation_datetime = DateTime.strptime(latest_post['device']['created'], "%Y-%m-%d %H:%M:%S %Z").to_date
      latest_local_timestamp = self.posts.order(:timestamp).size > 0 ? self.posts.order(:timestamp).last.timestamp : nil
      date =  if latest_local_timestamp
                installation_datetime < latest_local_timestamp ? latest_local_timestamp : installation_datetime
              else
                installation_datetime
              end
      if date == latest_local_timestamp # remove all posts from that day, so hopefully we'll get no duplicates
        self.posts.where("timestamp >= ?", Date.new(latest_local_timestamp.year, latest_local_timestamp.month, latest_local_timestamp.day)).destroy_all
      end
      date = date.to_date
      loop do
        break if date == Date.today
        if posts = client.get_posts_for_date(date)
          posts.each do | post |
            Post.create({
              timestamp: DateTime.strptime(post["timestamp"], "%Y-%m-%d %H:%M:%S %Z"),
              temp: post["temp"],
              hum: post["hum"],
              co: post["co"],
              no2: post["no2"],
              light: post["light"],
              noise: post["noise"],
              bat: post["bat"],
              panel: post["panel"],
              nets: post["nets"],
              insert_datetime: DateTime.strptime(post["insert_datetime"], "%Y-%m-%d %H:%M:%S %Z"),
              sck_device_id: self.id})
          end
        end
        date += 1
      end


    end

  end

end
