module Story
  module Utils
    def self.lib_dir
      ["#{File.dirname(File.expand_path($0))}/../lib/#{Meta::NAME}", "#{Gem.dir}/gems/#{Meta::NAME}-#{Meta::VERSION}/lib/#{Meta::NAME}"]
      .each {|lib| return i if File.readable? lib }
      raise LoadError
    end

    def self.setup_environment
      p File.exists? 'story_config.yml'
      if File.exists? 'story_config.yml' and config = YAML::load(File.open('story_config.yml'))
        p config
      end
      :development
    end

    private

    def load_additional_styles
      return settings.additional_stylesheets if sinatra_setting_exists? :additional_stylesheets
      false
    end

    def title *sections
      sections.each do |section|
        @title += "#{settings.title_separator}#{section.to_s}"
      end
    end

    def sinatra_setting_exists? setting
      settings.respond_to? setting
    end

    def title_type type_given = false
      @title = "(#{type_given}) #{@title}" if type_given
    end

    def get_last_session_url
      @last_session = request.cookies["session_url"] != "" ? request.cookies["session_url"] : '/'
    end

    def set_session_url
      response.set_cookie "session_url", request.path_info if request.path_info.match(/^e_/).is_a? NilClass and @last_session != request.path_info
    end

    def parse_file filename, extension = '', root = true
      file_path = "#{'.' if root}#{filename}.#{extension}"
      raise not_found if not File.exists? file_path
      content_type case extension
      when "xml" then "text/#{extension}"
      when "mp3", "mp4", "ogg", "mpeg" then "audio/#{extension}"
      when "json", "pdf", "zip" then "application/#{extension}"
      when "png", "gif", "jpg", "jpeg", "svg", "tiff" then "image/#{extension}"
      else "text/plain"
      end
      File.read file_path
    end
  end
end