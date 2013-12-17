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
          @errors.push e.message
          false
        end
      end

      def sinatra_setting_exists? setting
        settings.respond_to? setting
      end

      def get_list_of_db_adapters
        ["jdbc", "fb", "frontbase", "mysql", "openbase", "oci", "postgresql", "sqlite3", "sqlite2", "sqlite", "sqlserver", "sybsql"]
      end

      def concat_default_and_user_adapters?
        sinatra_setting_exists? :db_adapters and settings.db_adapters.select { |b| b.is_a? (String) }.size > 0 and settings.db_adapters.is_a? (Array)
      end

      def parse_adapters
        default_adapters = get_list_of_db_adapters
        if concat_default_and_user_adapters? then default_adapters.concat(settings.db_adapters.each(&:downcase!))
        else default_adapters end
      end

      def define_db_error_type adapters, config
        case
          when !config.has_key?("adapter") && !adapters.include?(config["adapter"].downcase) then 0
          when !config.has_key?("adapter") then 1
          when !config.has_key?("database") then 2
          when !config.has_key?("adapter") && !config.has_key?("database") then 3
        end
      end 

      def some_db_errors_in config
        adapters = parse_adapters
        if !config.has_key?("adapter") or !config.has_key?("database") or !(config.has_key?("adapter") and adapters.include?(config["adapter"].downcase)) then
          @db_error_type = define_db_error_type adapters, config
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