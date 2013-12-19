module Story
  class Base < Sinatra::Base
    include Utils
    include Errors
    include DB::Utils


    configure do
      config = YAML::load(File.open('story_config.yml'))
      enable :show_exceptions
      set :environment, File.exists?('story_config.yml') && config.is_a?(Hash) && config.has_key?("environment") ? config["environment"].to_sym : :development
      set :views, settings.views.to_s.gsub(/views$/, 'templates/story')
      set :blog_title, Meta::DEFAULT_BLOG_TITLE
      set :charset, Meta::CHARSET
      set :static_ext, nil
      set :sass, Compass.sass_engine_options
      set :story_config_root, Meta::CONFIG_ROOT
      set :title_separator, ': '
      set :db_adapters, nil
    end

    before do initialization end

    get %r{(.*\..*)} do |url|
      parse_static_files_from url
    end

    get '/' do
      title "Posts"
      slim :index
    end

    get %r{e([0-9]+)} do |error|
      status error
      slim :error_page
    end

    get %r{e_([a-zA-Z0-9_]+)} do |error|
      redirect @last_session != request.path_info ? @last_session : '/' if @errors.size == 0
      title @errors.size > 0 ? @errors.first : "Error occured"
      title_type :error
      slim :error_page
    end

    after do
      set_session_url
    end

    not_found do
      status 404
      title "404"
      'Page not found'
    end
  end
end