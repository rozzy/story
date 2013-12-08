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
  end
end