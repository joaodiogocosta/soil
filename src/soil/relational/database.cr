module Relational
  class Database
    @db : DB::Database
    @transactions = {} of UInt64 => DB::Transaction

    # :nodoc:
    def self.instance
      @@instance ||= new
    end

    # Executes a SQL statement
    #
    # ```
    # Relational.exec "SELECT * FROM users"
    # ```
    def self.exec(*args, **options)
      instance.exec(*args, **options)
    end

    # Executes a SQL statement and returns a single value
    #
    # ```
    # Relational.exec "SELECT * FROM users"
    # ```
    def self.scalar(*args, **options)
      instance.scalar(*args, **options)
    end

    # Retrieves a connection and closes it after evaluating the encapsulated
    # code
    #
    # ```
    # Relational.connection do |conn|
    #   conn.execute "SELECT * FROM users"
    # end
    # ```
    def connection
      instance.connection do |conn|
        yield conn
      end
    end

    # Retrieves a connection and closes it after evaluating the encapsulated
    # code
    #
    # ```
    # Relational.transaction do
    #   arthur.withdrawal(100)
    #   thomas.deposit(100)
    # end
    # ```
    def self.transaction
      instance.transaction do |tx|
        yield tx
      end
    end

    # :nodoc:
    def exec(*args, **options)
      connection do |conn|
        conn.exec(*args, **options)
      end
    end

    # :nodoc:
    def scalar(*args, **options)
      connection do |conn|
        conn.scalar(*args, **options)
      end
    end

    # :nodoc:
    def connection(&block)
      if !current_transaction?
        new_connection do |conn|
          yield conn
        end
      else
        yield current_transaction.connection
      end
    end

    # :nodoc:
    def transaction
      previous_transaction = maybe_current_transaction
      connection do |conn|
        conn.transaction do |tx|
          self.current_transaction = tx
          yield tx
        end
      end
    ensure
      self.current_transaction = previous_transaction
    end

    private def initialize(host = nil)
      @db = DB.open "postgres://postgres@0.0.0.0"
    end

    private def current_transaction?
      !@transactions.empty? && !maybe_current_transaction.nil?
    end

    private def current_transaction
      @transactions[Fiber.current.object_id]
    end

    private def maybe_current_transaction
      @transactions[Fiber.current.object_id]?
    end

    private def current_transaction=(transaction : DB::Transaction)
      @transactions[Fiber.current.object_id] = transaction
    end

    private def current_transaction=(transaction : Nil)
      @transactions.delete(Fiber.current.object_id)
    end

    private def new_connection(&block)
      conn = @db.checkout
      begin
        yield conn
      rescue error
        raise error
      ensure
        conn.release
      end
    end
  end
end
