# workers/hard_worker.rb

class HardWorker
  include Sidekiq::Worker

  def perform()
    puts "HELLO"
  end
end
