require "story/version"
require "sinatra"

module Story
  class Story < Sinatra::Base
    $db = Hash.new

    include DataBase
    include Router
  end
end
