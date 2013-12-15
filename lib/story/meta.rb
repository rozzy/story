module Story
  module Meta
    NAME = 'story'
    VERSION = '0.0.4'
    CHARSET = 'utf-8'
    DEFAULT_BLOG_TITLE = 'Personal Blog'
  end

  module Errors
    def raise_unsupported_db_adapter file, config
      raise error "Database configuration file contains errors!", "Unsupported database adapter <b>#{config["adapter"]}</b> in database config file (#{file})."
    end

    def raise_no_db_adapter_specified file, config
      raise error "Database configuration file contains errors!", "No database adapter specified in database config file (#{file})."
    end

    def raise_no_database_specified file, config
      raise error "Database configuration file contains errors!", "No database file or data specified in database config file (#{file})."
    end

    def raise_no_db_adapter_and_database_specified file, config
      raise error "Database configuration file contains errors!", "No database file or data specified in database config file (#{file})."
    end
  end
end