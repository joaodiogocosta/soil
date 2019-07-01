module Relational
  abstract class Migration
    include Interface::Schema

    macro inherited
      Relational::Migrator.register_migration(database, {{ @type.name.id }})
    end

    macro version(number)
      def self.version
        {{ number.id }}
      end
    end

    macro database(name)
      def self.database
        {{ name.id.stringify }}
      end
    end

    abstract def up
    abstract def down

    def self.database
      :default
    end

    def self.version
      0
    end

    def self.migrate(direction)
      instance = new
      case direction.to_s
      when "up"
        instance.forward
      when "down"
        instance.backwards
      end
    end

    def forward(transaction = true)
      logger.info "====> Migrating #{self.class.name} (version #{self.class.version})"
      if transaction
        Database.transaction { up }
      else
        up
      end
    end

    def backwards(transaction = true)
      logger.info "====> Rolling back #{self.class.name} (version #{self.class.version})"
      if transaction
        Database.transaction { down }
      else
        down
      end
    end

    def logger
      Relational.config.logger
    end
  end
end
