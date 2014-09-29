namespace :sck do
  namespace :pull do

    desc "Pull and overwrite all Smart Citizen Kit data held in the system with data from smartcitizen.me, aka data reboot."
    task all: :environment do
      SckDevice.all.each do | kit |

        next unless kit.SCK_API_key

        kit.readings.destroy_all
        kit.get_readings
        #        data_endpoint = "http://api.smartcitizen.me/v0.0.1/"+kit.SCK_API_key+"/"+kit.SCK_id+"/posts.json"
      end
    end
  end
end

