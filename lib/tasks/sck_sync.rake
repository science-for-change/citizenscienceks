namespace :sck do
  namespace :pull do

    desc "Pull and overwrite all Smart Citizen Kit data held in the system with data from smartcitizen.me, aka data reboot."
    task all: :environment do
      SckDevice.all.each do | kit |

      end
    end
  end
end

