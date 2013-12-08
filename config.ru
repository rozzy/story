require 'story'
require 'slim'
require 'sass'
require 'compass'

class MyBlog < Story::Base
  configure do
    # set :views, "views"
    set :blog_title, 'Rozzy Blog'
    set :additional_stylesheets, ["styles/style.css"]
    set :static_ext, ["txt", "md"]
  end
end
run MyBlog

# app = Story::Base.new
# app.settings.blog_title = 'Rozzy Blog'
# run app