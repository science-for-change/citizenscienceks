module Citizenscienceks
  class App < Padrino::Application
    use ActiveRecord::ConnectionAdapters::ConnectionManagement
    register Padrino::Mailer
    register Padrino::Helpers
    register CompassInitializer
    enable :sessions

#    use Rack::Auth::Basic, "Restricted Area" do |username, password|
#      username == 'citsci' and password == 'kosov0'
#    end

    get "/" do
      @blogs = BlogPost.first(3)
      render "frontpage"
    end

    get "/apis" do
      render "apis"
    end

    get 'smart_citizen_kits.geojson' do
      content_type :json
      SckDevice.all.to_json
    end

    get :site_smart_citizen_kit_daily_no2, map: '/sites/:site_id/smart_citizen_kit_daily_no2.json' do
      content_type :json
      Site.find(params[:site_id]).sck_devices.take.daily_average_no2({date_from: Date.new(2014,10,1), date_to: Date.new(2014,10,15), ppm: true}).to_json
    end

    get :site_smart_citizen_kit_data, map: '/sites/:site_id/smart_citizen_kit_data.json' do
      content_type :json
      {
        no2_daily_averages: Site.find(params[:site_id]).sck_devices.take.daily_average_no2({date_from: Date.new(2014,10,1), date_to: Date.new(2014,10,16), ppm: true}),
        co_daily_averages: Site.find(params[:site_id]).sck_devices.take.daily_average_co({date_from: Date.new(2014,10,1), date_to: Date.new(2014,10,16), ppm: true})
      }.to_json
    end

    get 'sites.geojson' do
      content_type :json
      Site.all.to_json
    end

    get :site_diffusion_tubes, map: '/sites/:site_id/diffusion_tubes.json' do
      diffusion_tubes = Site.find(params[:site_id]).diffusion_tubes
      content_type :json
      diffusion_tubes.to_json
    end

    get :site_ghost_wipes, map: '/sites/:site_id/ghost_wipes.json' do
      ghost_wipes = Site.find(params[:site_id]).ghost_wipes
      content_type :json
      ghost_wipes.to_json
    end

    ##
    # Caching support.
    #
    # register Padrino::Cache
    # enable :caching
    #
    # You can customize caching store engines:
    #
    # set :cache, Padrino::Cache.new(:LRUHash) # Keeps cached values in memory
    # set :cache, Padrino::Cache.new(:Memcached) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Memcached, '127.0.0.1:11211', :exception_retry_limit => 1)
    # set :cache, Padrino::Cache.new(:Memcached, :backend => memcached_or_dalli_instance)
    # set :cache, Padrino::Cache.new(:Redis) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Redis, :host => '127.0.0.1', :port => 6379, :db => 0)
    # set :cache, Padrino::Cache.new(:Redis, :backend => redis_instance)
    # set :cache, Padrino::Cache.new(:Mongo) # Uses default server at localhost
    # set :cache, Padrino::Cache.new(:Mongo, :backend => mongo_client_instance)
    # set :cache, Padrino::Cache.new(:File, :dir => Padrino.root('tmp', app_name.to_s, 'cache')) # default choice
    #

    ##
    # Application configuration options.
    #
    # set :raise_errors, true       # Raise exceptions (will stop application) (default for test)
    # set :dump_errors, true        # Exception backtraces are written to STDERR (default for production/development)
    # set :show_exceptions, true    # Shows a stack trace in browser (default for development)
    # set :logging, true            # Logging in STDOUT for development and file for production (default only for development)
    # set :public_folder, 'foo/bar' # Location for static assets (default root/public)
    # set :reload, false            # Reload application files (default in development)
    # set :default_builder, 'foo'   # Set a custom form builder (default 'StandardFormBuilder')
    # set :locale_path, 'bar'       # Set path for I18n translations (default your_apps_root_path/locale)
    # disable :sessions             # Disabled sessions by default (enable if needed)
    # disable :flash                # Disables sinatra-flash (enabled by default if Sinatra::Flash is defined)
    # layout  :my_layout            # Layout can be in views/layouts/foo.ext or views/foo.ext (default :application)
    #

    ##
    # You can configure for a specified environment like:
    #
    #   configure :development do
    #     set :foo, :bar
    #     disable :asset_stamp # no asset timestamping for dev
    #   end
    #

    ##
    # You can manage errors like:
    #
    #   error 404 do
    #     render 'errors/404'
    #   end
    #
    #   error 500 do
    #     render 'errors/500'
    #   end
    #
  end
end
