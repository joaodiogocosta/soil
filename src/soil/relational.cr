require "db"
require "./relational/interface/schema"
require "./relational/migrator"
require "./relational/**"

module Relational
  alias DBAny = DB::Any

  @@config = {} of String => Config

  def self.config(database_name = nil)
    database_name = (database_name || "default").to_s
    if @@config.has_key?(database_name)
      @@config[database_name]
    else
      @@config[database_name] = Config.new(database_name)
    end
  end

  def self.configure
    yield config
  end

  def self.register_adapter(name, adapter)
    config.dialects[name.to_s] = adapter.new
  end
end
