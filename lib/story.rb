require 'story/version'
require 'sinatra'

module Story
  class Base < Sinatra::Base
    get '/' do
      p "Test"
    end
  end
end