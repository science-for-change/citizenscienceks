require 'sidekiq'

worker_processes 3
timeout 30
preload_app true

before_fork do |server, worker|
  # Spawn Sidekiq worker inside the current process.
  @worker_pid = spawn('bundle exec sidekiq -C ./config/sidekiq.yml -r ./config/boot.rb')
  t = Thread.new {
    Process.wait(@worker_pid)
    puts "Worker died. Bouncing unicorn."
    Process.kill 'QUIT', Process.pid
  }
  # Just in case
  t.abort_on_exception = true
end

after_fork do |server, worker|
  Sidekiq.configure_client do |config|
    config.redis = { :size => 1 } # Limit the client size, see http://manuel.manuelles.nl/blog/2012/11/13/sidekiq-on-heroku-with-redistogo-nano/
  end
  Sidekiq.configure_server do |config|
    config.redis = { :size => 2 } # Limit the server size, see http://manuel.manuelles.nl/blog/2012/11/13/sidekiq-on-heroku-with-redistogo-nano/
  end
end
