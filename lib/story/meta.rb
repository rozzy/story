module Story
  module Meta
    NAME = 'story'
    VERSION = '0.0.5'
    CHARSET = 'utf-8'
    DEFAULT_BLOG_TITLE = 'Personal Blog'
    CONFIG_ROOT = '/'
  end

  module Errors
    class DatabaseError < Exception; end
    class ConnectionError < Exception; end

    private

    def print_config_file_location
      "#{"STORY_GEM_ROOT/" if !(/#{Gem.dir}/ =~ file).is_a? NilClass }#{File.basename(File.dirname(file))}/#{File.basename(file)}"
    end

    def raise_unsupported_db_adapter file, config
      "Unsupported database adapter <b>#{config["adapter"]}</b> in database config file (#{print_config_file_location})."
    end

    def raise_no_db_adapter_specified file, config
      "No database adapter specified in database config file (#{print_config_file_location})."
    end

    def raise_no_database_specified file, config
      "No database file or data specified in database config file (#{print_config_file_location})."
    end

    def raise_no_db_adapter_and_database_specified file, config
      "No database file and data specified in database config file (#{print_config_file_location})."
    end

    def check_on_error_page
      @on_error_page = request.path_info.downcase.match "/e_([a-z0-9_]+)"
    end
  end
end