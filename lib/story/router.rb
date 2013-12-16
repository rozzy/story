module Story
  class Base < Sinatra::Base
    include Utils
    include Errors
    include DB::Utils

    configure do
      enable :show_exceptions
      set :environment, :development
      set :views, settings.views.to_s.gsub(/views$/, '/templates/story')
      set :blog_title, Meta::DEFAULT_BLOG_TITLE
      set :charset, Meta::CHARSET
      set :static_ext, ''
      set :sass, Compass.sass_engine_options
      set :title_separator, " | "
      set :db_adapters, nil
    end

    before do
      begin
        @title = settings.blog_title
        @header_needed = @footer_needed = true
        @additional_styles ||= load_additional_styles
        raise ConnectionError if not db_connected?
        get_last_session_url
      rescue ConnectionError => e
        check_on_error_page
        if not @on_error_page then redirect '/e_config' end
      end
    end

    get %r{(.*\..*)} do |url|
      user_ext = settings.static_ext
      user_ext = user_ext.split '|' if user_ext.is_a? String
      expr = /(.*)\.(json|zip|md|txt|mp3|mp4|ogg|mpeg|pdf|rtf|doc|slim|xml|png|gif|jpg|jpeg|svg|tiff|#{user_ext.join('|')})/
      if data = url.match(expr)
        parse_file data[1], data[2]
      else raise not_found end
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