require 'story/meta'
require 'sinatra'

module Story
  class Base < Sinatra::Base
    configure do
      set :views, settings.views.to_s.gsub(/views$/, 'story/templates/story')
      set :blog_title, Meta::DEFAULT_BLOG_TITLE
      set :charset, Meta::CHARSET
    end

    def load_additional_styles
      begin
        settings.additional_stylesheets
        additional_styles = true
      rescue NoMethodError
      ensure
        additional_styles = false
      end
    end

    get '/' do
      slim :index
    end
  end

  def self.lib_dir
    ["#{File.dirname(File.expand_path($0))}/../lib/#{Meta::NAME}", "#{Gem.dir}/gems/#{Meta::NAME}-#{Meta::VERSION}/lib/#{Meta::NAME}"]
    .each {|i| return i if File.readable?(i) }
    raise LoadError
  end
end