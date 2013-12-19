module Story
  module Utils
    def self.lib_dir
      ["#{File.dirname(File.expand_path($0))}/../lib/#{Meta::NAME}", "#{Gem.dir}/gems/#{Meta::NAME}-#{Meta::VERSION}/lib/#{Meta::NAME}"]
      .each {|lib| return i if File.readable? lib }
      raise LoadError
    end

    def self.sss
      p methods #Dir.glob settings.story_config_root
      if File.exists? 'story_config.yml' and config = YAML::load(File.open('story_config.yml'))
        p config
      end
      :development
    end

    private

    def initialization
      begin
        @title = settings.blog_title
        @header_needed = @footer_needed = true
        @additional_styles ||= load_additional_styles
        raise ConnectionError if not db_connected?
        get_last_session_url
      rescue ConnectionError => e
        check_on_error_page
        if not @on_error_page then redirect '/e_config' end
      end
    end

    def load_additional_styles
      return settings.additional_stylesheets if sinatra_setting_exists? :additional_stylesheets
      false
    end

    def title *sections
      sections.each do |section|
        @title += "#{settings.title_separator}#{section.to_s}"
      end
    end

    def parse_static_files_from url
      user_ext = sinatra_setting_exists?(:static_ext) && settings.static_ext.is_a?(String) ? settings.static_ext.split('|') : ''
      expr = /(.*)\.(json|zip|md|txt|mp3|mp4|ogg|mpeg|pdf|rtf|doc|slim|xml|png|gif|jpg|jpeg|svg|tiff|#{user_ext.join('|')})/
      if data = url.match(expr)
        parse_file data[1], data[2]
      else raise not_found end
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