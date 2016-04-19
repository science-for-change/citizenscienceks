require 'open-uri'

class ProcessSidepackFile
  include Sidekiq::Worker

  def perform(upload_id)
    if upload = Upload.where(id: upload_id).take
      raw = open(upload.file.url).read
      session = {
        model: raw.match(/Model:,(.*)\r$/)[1],
        model_number: raw.match(/Model Number:,(.*)\r$/)[1],
        serial_number: raw.match(/Serial Number:,(.*)\r$/)[1],
        test_id: raw.match(/Test ID:,(.*)\r$/)[1],
        test_abbreviation: raw.match(/Test Abbreviation:,(.*)\r$/)[1],
        start_timestamp: start_timestamp(raw),
        duration: duration(raw),
        time_constant: raw.match(/Time constant \(seconds\):,(.*)\r$/)[1].to_i,
        log_interval: raw.match(/Log Interval \(mm:ss\):,(.*)\r$/)[1],
        number_of_points: raw.match(/Number of points:,(.*)\r$/)[1].to_i,
        notes: raw.match(/Notes:,(.*)\r$/)[1],
        statistics_channel: raw.match(/Statistics,Channel:,(.*)\r$/)[1],
        units: raw.match(/Units:,(.*)\r$/)[1],
        average: raw.match(/Average:,(.*)\r$/)[1].to_f,
        minimum: raw.match(/Minimum:,(.*)\r$/)[1].to_f,
        minimum_timestamp: maximum_timestamp(raw),
        maximum: raw.match(/Maximum:,(.*)\r$/)[1].to_f,
        maximum_timestamp: minimum_timestamp(raw)
      }
      SidepackSession.create(session)
    end
  end

  def duration(raw)
    duration_match = raw.match(/Duration \(dd:hh:mm:ss\):,(\d{1,}):(\d\d):(\d\d):(\d\d)\r$/)
    days = duration_match[1].to_i
    hours = duration_match[2].to_i
    minutes = duration_match[3].to_i
    seconds = duration_match[4].to_i
    (86400 * days) + (3600 * hours) + (60 * minutes) + seconds
  end

  def start_timestamp(raw)
    date_match = raw.match(/Start Date:,(\d\d)\/(\d\d)\/(\d\d\d\d)\r$/)
    day = date_match[1]
    month = date_match[2]
    year = date_match[3]
    time_match = raw.match(/Start Time:,(\d\d):(\d\d):(\d\d)\r$/)
    hour = time_match[1]
    minute = time_match[2]
    second = time_match[3]
    Time.new(year, month, day, hour, minute, second, 0) # we do not know the right timezone, so default to UTC
  end

  def minimum_timestamp(raw)
    date_match = raw.match(/Date of Minimum:,(\d\d)\/(\d\d)\/(\d\d\d\d)\r$/)
    day = date_match[1]
    month = date_match[2]
    year = date_match[3]
    time_match = raw.match(/Time of Minimum:,(\d\d):(\d\d):(\d\d)\r$/)
    hour = time_match[1]
    minute = time_match[2]
    second = time_match[3]
    Time.new(year, month, day, hour, minute, second, 0) # we do not know the right timezone, so default to UTC
  end

  def maximum_timestamp(raw)
    date_match = raw.match(/Date of Maximum:,(\d\d)\/(\d\d)\/(\d\d\d\d)\r$/)
    day = date_match[1]
    month = date_match[2]
    year = date_match[3]
    time_match = raw.match(/Time of Maximum:,(\d\d):(\d\d):(\d\d)\r$/)
    hour = time_match[1]
    minute = time_match[2]
    second = time_match[3]
    Time.new(year, month, day, hour, minute, second, 0) # we do not know the right timezone, so default to UTC
  end
end
