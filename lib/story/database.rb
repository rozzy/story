module Story
  module DataBase
    def self.included r
      self.load_config
      self.setup_database
    end

    def self.load_config
      YAML::load(File.open('config/database.yml'))[ENV['RACK_ENV']].each do |key, value|
        $db[:"#{key}"] = value
      end
    end

    def self.setup_database
      ActiveRecord::Base.establish_connection(
        adapter: $db[:adapter],
        host: $db[:db_host],
        database: $db[:db_name],
        username: $db[:db_username],
        password: $db[:db_password]
      )
    end
  end
end