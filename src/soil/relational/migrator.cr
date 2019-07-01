module Relational
  module Migrator
    extend self

    @@migrations = {} of String => Array(Migration.class)

    def migrations
      @@migrations
    end

    def register_migration(database, migration_klass)
      database = database.to_s
      if !@@migrations.has_key?(database)
        @@migrations[database] = [] of Migration.class
      end
        @@migrations[database] << migration_klass
    end

    def run(direction, database = "default")
      prepare_migrations_table!
      last_version = last_migration_version

      filter(database).each do |database_migrations, migrations|
        select_and_sort(migrations, last_version, direction).each do |migration_klass|
          migration_klass.migrate(direction)
          store_latest_migration_version(migration_klass.version, direction)
        end
      end
    end

    def store_latest_migration_version(version, direction)
      if direction == "up"
        Interface::General.insert(schema_table_name, { "version" => version })
      else
        Database.exec("DELETE FROM #{schema_table_name} WHERE version = #{version}")
      end
    end

    def filter(name)
      @@migrations.select do |database_name, _|
        name == "all" || name == database_name
      end
    end

    def select_and_sort(migrations, last_version, direction)
      if direction == "up"
        migrations.select do |migration|
          migration.version.to_i > last_version
        end.sort_by &.version
      else
        migrations.select do |migration|
          migration.version.to_i <= last_version
        end.sort_by(&.version).reverse
      end
    end

    def last_migration_version
      query = "SELECT MAX(version) FROM #{schema_table_name}"
      version = Database.scalar(query).as(Int32?)
      version || 0
    end

    def prepare_migrations_table!
      if !Interface::Schema.table_exists?(schema_table_name)
        Interface::Schema.create_table(schema_table_name, id: false) do |t|
          t.column :version, :integer
        end
      end
    end

    def generate_migration(migration_name, database_name = "default")
      timestamp = Time.now.epoch
      path = migrations_path(database_name)
      filename = "#{migration_name.underscore}_#{timestamp}.cr"
      contents = migration_contents(migration_name, database_name, timestamp)
      Dir.mkdir_p(path) unless Dir.exists?(path)
      File.write(File.join(path, filename), contents)
    end

    def migration_contents(migration_name, database_name, timestamp)
      contents = <<-SQL
      class #{migration_name}#{timestamp} < Relational::Migration
        #{"database \"" + database_name + "\""}
        version #{timestamp}

        def up
        end

        def down
        end
      end
      SQL
    end

    def migrations_path(database_name)
      Relational.config(database_name).migrations_path
    end

    def schema_table_name
      :relational_schema_migrations
    end
  end
end
