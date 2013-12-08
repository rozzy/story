require 'story/meta'
require 'sinatra'

module Story
  def self.lib_dir
    t = ["#{File.dirname(File.expand_path($0))}/../lib/#{Meta::NAME}", "#{Gem.dir}/gems/#{Meta::NAME}-#{Meta::VERSION}/lib/#{Meta::NAME}"]
    t.each {|i| return i if File.readable?(i) }
    raise "both paths are invalid: #{t}"
  end

  class Base < Sinatra::Base
    configure do
      set :views, settings.views.gsub /views$/, 'story/templates/story'
    end

    get '/' do
      slim :index
    end
  end
end