module Story
  class Base < Sinatra::Base
    include Utils

    configure do
      set :views, settings.views.to_s.gsub(/views$/, '/templates/story')
      set :blog_title, Meta::DEFAULT_BLOG_TITLE
      set :charset, Meta::CHARSET
      set :static_ext, ''
      set :sass, Compass.sass_engine_options
    end

    before do
      @additional_styles ||= load_additional_styles
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
      slim :index
    end

    not_found do
      'Page not found'
    end
  end
end