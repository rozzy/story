module Story
  module DB
    module Utils
      def db_connected?
        @errors ||= []
        begin
          configuration_file = File.exists?('dbconfig.yml') ? 'dbconfig.yml' : File.join(File.dirname(__FILE__), 'config.yml')
          dbconfig = parse_configuration_from configuration_file
          ActiveRecord::Base.logger = Logger.new STDERR
          ActiveRecord::Base.establish_connection dbconfig
          true
        rescue Errno::ENOENT
          @errors.push "Database configuration file not found."
          false
        rescue Errors::DatabaseError => e
          @errors.push e
          false
        end
      end

      def some_db_errors_in config
        default_adapters = ["jdbc", "fb", "frontbase", "mysql", "openbase", "oci", "postgresql", "sqlite3", "sqlite2", "sqlite", "sqlserver", "sybsql"]
        if settings.db_adapters.is_a? (Array) 
          if settings.db_adapters.select { |b| b.is_a? (String) }.size > 0
            adapters = default_adapters.concat(settings.db_adapters.each(&:downcase!))
          end
        else adapters = default_adapters end
        if !config.has_key?("adapter") or !config.has_key?("database") or !(config.has_key?("adapter") and adapters.include?(config["adapter"].downcase)) then
          @db_error_type = 0 if !(config.has_key?("adapter") and adapters.include?(config["adapter"].downcase))
          @db_error_type = 1 if !config.has_key?("adapter")
          @db_error_type = 2 if !config.has_key?("database")
          @db_error_type = 3 if !config.has_key?("adapter") and !config.has_key?("database")
          true
        else false end
      end

      def parse_configuration_from file
        config = YAML::load File.open file
        error_types = ["unsupported_db_adapter", "no_db_adapter_specified", "no_database_specified", "no_db_adapter_and_database_specified"]
        raise Errors::DatabaseError, send("raise_#{error_types[@db_error_type]}".to_sym, file, config) if some_db_errors_in config
        config
      end
    end
  end
end