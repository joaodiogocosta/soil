module Relational
  class Config
    property dialect : Dialects::Abstract
    property migrations_path : String
    property database_name : String
    getter logger

    @@dialects = {
      "null" => Dialects::Null.new,
      "postgres" => Dialects::Postgres.new
    }

    def self.dialects
      @@dialects
    end

    def initialize(database_name = "default")
      @dialect = self.class.dialects["null"]
      @database_name = database_name
      @migrations_path = "./db/migrations/#{database_name}"
      @logger = Logger.new(STDOUT)
    end

    def dialect=(name)
      @dialect = resolve_dialect(name)
    end

    private def resolve_dialect(name)
      @@dialects[name.to_s]
    end
  end

end
