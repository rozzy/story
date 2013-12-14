module Story
  module DB
    module Utils
      def db_connected?
        @errors ||= ''
        begin
          configuration_file = File.exists? 'dbconfig.yml' ? 'dbconfig.yml' : File.join File.dirname(__FILE__), 'dbconfig.yml'
          dbconfig = YAML::load File.open configuration_file
          ActiveRecord::Base.logger = Logger.new STDERR
          ActiveRecord::Base.establish_connection dbconfig
          true
        rescue Errno::ENOENT
          @errors += "Database configuration file not found."
          false
        rescue => e
          @errors += e.to_s
          false
        end
      end
    end
  end
end