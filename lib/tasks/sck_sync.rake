namespace :sck do
  desc "Update all local Smart Citizen Kit data from smartcitizen.me cloud db."
  task sync: :environment do
    SckDevice.all.each do | kit |
      kit.get_all_posts
    end
  end
end

