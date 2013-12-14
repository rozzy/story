require 'sqlite3'
require 'story'

db = SQLite3::Database.new 'file.db'

{ 'one' => 1, 'two' => 2 }.each do |pair|
  db.execute 'insert into numbers values (?, ?)', pair
end

class MyBlog < Story::Base
  configure do
    set :views, "views"
    set :styles_path, "styles"
    set :blog_title, 'Rozzy Blog'
    set :static_ext, ["txt", "md"]
    set :title_separator, ": "
  end

  get '/:file.css' do |file|
    return parse_file file, "css", false if File.exists? "#{file}.css"
    return sass :"#{settings.styles_path}/#{file}" if File.exists? "#{settings.views}/#{settings.styles_path}/#{file}.sass"
    raise not_found
  end

  get '/tt' do
    title "All posts"
    slim :index
  end
end
# Another start version
# app = Story::Base.new
# app.settings.blog_title = 'Rozzy Blog'
# run app