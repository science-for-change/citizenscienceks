class SckDevice < ActiveRecord::Base
  before_save :get_attributes
  belongs_to :site
  has_many :posts

  def daily_average_no2(**args)
    date_from = args[:date_from] || nil
    date_to = args[:date_to] || nil
    ppm = args[:ppm] || nil
    return [] if date_from.nil? || date_to.nil?

#    unless date_from && date_to
#      date_from = posts.order(:timestamp).first.timestamp
#      date_to = posts.order(:timestamp).last.timestamp
#    end

    data = []
    while date_from <= date_to do
      average = average_no2({
        date_from: date_from,
        date_to: date_from,
        ppm: ppm
      })

      if average
        data << {
          timestamp: date_from,
          average_no2: average.to_f.round(2)
        }
      end
      date_from += 1
    end
    data
  end

  def daily_average_co(**args)
    date_from = args[:date_from] || nil
    date_to = args[:date_to] || nil
    ppm = args[:ppm] || nil
    return [] if date_from.nil? || date_to.nil?

#    unless date_from && date_to
#      date_from = posts.order(:timestamp).first.timestamp
#      date_to = posts.order(:timestamp).last.timestamp
#    end

    data = []
    while date_from <= date_to do
      average = average_co({
        date_from: date_from,
        date_to: date_from,
        ppm: ppm
      })

      if average
        data << {
          timestamp: date_from,
          average_co: average.to_f.round(2)
        }
      end
      date_from += 1
    end
    data
  end

  def average_no2(**args)
    date_from = args[:date_from] || nil
    date_to = args[:date_to] || nil
    ppm = args[:ppm] || nil
    redis_key = self.id.to_s+"no2"+date_from.to_s+date_to.to_s+ppm.to_s

    if cached_result = $redis.get(redis_key)
      return cached_result
    end

    p = if date_from && date_to
              posts.where(:timestamp => date_from.beginning_of_day...date_to.end_of_day).where("no2 > 0.01").select(:no2)
            else
              posts.where("no2 > 0.01").select(:no2)
            end

    if ppm
      result = p.map(&:no2_ppm).sum / p.size.to_f
    else
      result = p.map(&:no2).sum / p.size.to_f
    end
    $redis.set(redis_key, result)
    return nil if p.empty?
    result
  end

  def average_co(**args)
    date_from = args[:date_from] || nil
    date_to = args[:date_to] || nil
    ppm = args[:ppm] || nil
    redis_key = self.id.to_s+"co"+date_from.to_s+date_to.to_s+ppm.to_s

    if cached_result = $redis.get(redis_key)
      return cached_result
    end

    p = if date_from && date_to
              posts.where(:timestamp => date_from.beginning_of_day...date_to.end_of_day).where("co > 0.01").select(:co)
            else
              posts.where("co > 0.01").select(:co)
            end

    if ppm
      result = p.map(&:co_ppm).sum / p.size.to_f
    else
      result = p.map(&:co).sum / p.size.to_f
    end
    $redis.set(redis_key, result)
    return nil if p.empty?
    result
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

    client = SmartCitizenClient.new self.SCK_API_key, self.SCK_id

    if post = client.get_latest_post

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

    client = SmartCitizenClient.new self.SCK_API_key, self.SCK_id

    if latest_post = client.get_latest_post

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
