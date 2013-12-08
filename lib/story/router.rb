module Story
  class Base < Sinatra::Base
    include Utils

    configure do
      set :views, settings.views.to_s.gsub(/views$/, '/templates/story')
      set :blog_title, Meta::DEFAULT_BLOG_TITLE
      set :charset, Meta::CHARSET
      set :static_ext, ""
    end

    before do
      @additional_styles ||= load_additional_styles
    end

    get %r{(.*\..*)} do |url|
      user_ext = settings.static_ext
      user_ext = user_ext.split "|" if user_ext.is_a? String
      expr = /(.*)\.(css|js|json|zip|md|txt|mp3|mp4|ogg|mpeg|pdf|rtf|doc|slim|xml|png|gif|jpg|jpeg|svg|tiff|#{user_ext.join("|")})/
      if data = url.match(expr)
        raise not_found if not File.exists? ".#{data[1]}.#{data[2]}"
        content_type case data[2]
        when "css", "xml" then "text/#{data[2]}"
        when "js" then "text/javascript"
        when "mp3", "mp4", "ogg", "mpeg" then "audio/#{data[2]}"
        when "json", "pdf", "zip" then "application/#{data[2]}"
        when "png", "gif", "jpg", "jpeg", "svg", "tiff" then "image/#{data[2]}"
        else "text/plain"
        end
        File.read ".#{data[1]}.#{data[2]}"
      else
        raise not_found
      end
    end

    get '/' do
      slim :index
    end

    not_found do
      'Page not found'
    end
  end
end