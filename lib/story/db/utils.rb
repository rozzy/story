module Story
  module DB
    module Utils
      def db_connected?
        @errors ||= ''
        begin
          configuration_file = File.exists?('dbconfig.yml') ? 'dbconfig.yml' : File.join(File.dirname(__FILE__), 'config.yml')
          dbconfig = parse_configuration_from configuration_file
          ActiveRecord::Base.logger = Logger.new STDERR
          ActiveRecord::Base.establish_connection dbconfig
          true
        rescue Errno::ENOENT
          @errors += "Database configuration file not found."
          false
        rescue => e
          p e, e.backtrace
          @errors += e.to_s
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

        !config["adapter"] || !config["database"] || !adapters.include?(config["database"].downcase)
      end

      def parse_configuration_from file
        config = YAML::load File.open file
        raise error "Database configuration file contains errors." if some_db_errors_in config
        config
      end
    end
  end
end