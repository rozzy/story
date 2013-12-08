require 'story/meta'
require 'sinatra'

module Story
  class Base < Sinatra::Base
    attr_accessor :additional_styles

    configure do
      set :views, settings.views.to_s.gsub(/views$/, 'story/templates/story')
      set :blog_title, Meta::DEFAULT_BLOG_TITLE
      set :charset, Meta::CHARSET
      set :static_ext, false
    end

    def load_additional_styles
      begin
        settings.additional_stylesheets
      rescue NoMethodError
      end
    end

    before do
      @additional_styles ||= load_additional_styles
    end

    get %r{(.*\..*)} do |url|
      if data = url.match(/(.*)\.(css|js|json|zip|mp3|mp4|ogg|mpeg|pdf|slim|xml|png|gif|jpg|jpeg|svg|tiff|#{settings.static_ext})/)
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
      p settings.static_ext
      slim :index
    end

    not_found do
      'Page not found'
    end
  end

  def self.lib_dir
    ["#{File.dirname(File.expand_path($0))}/../lib/#{Meta::NAME}", "#{Gem.dir}/gems/#{Meta::NAME}-#{Meta::VERSION}/lib/#{Meta::NAME}"]
    .each {|lib| return i if File.readable? lib }
    raise LoadError
  end
end