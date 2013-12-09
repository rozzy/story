module Story
  module Utils
    def load_additional_styles
      begin
        settings.additional_stylesheets
      rescue NoMethodError
      end
    end

    def self.lib_dir
      ["#{File.dirname(File.expand_path($0))}/../lib/#{Meta::NAME}", "#{Gem.dir}/gems/#{Meta::NAME}-#{Meta::VERSION}/lib/#{Meta::NAME}"]
      .each {|lib| return i if File.readable? lib }
      raise LoadError
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