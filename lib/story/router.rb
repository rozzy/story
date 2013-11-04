module Story
  module Router
    def self.included request
      request.get '/' do 
        p Post.count.to_s

        p = Post.new title: '12', body: '23'
        p.save
      end
    end
  end
end