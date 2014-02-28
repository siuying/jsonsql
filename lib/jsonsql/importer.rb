require 'sequel'
require 'json'

module Jsonsql
  class Importer
    SEQUEL_SUPPORTED_CLASSES = [Integer, String, Fixnum, Bignum, Float, BigDecimal, Date, DateTime, Time, Numeric, TrueClass, FalseClass]

    attr_reader :database, :table_name

    def initialize(database: Sequel.sqlite, table_name: "table")
      @table_name = table_name
      @database   = database
      @table_created = false
    end

    def table
      @table ||= @database[table_name.to_sym]
    end

    def import(files)
      database.transaction do
        files.each do |filename|
          import_jsonfile(filename)
        end
      end
    end

    def import_jsonfile(filename)
      row = JSON.parse(open(filename).read)
      create_table_if_needed(row)
      table.insert(row)
    end

    private
    def class_supported?(clazz)
      SEQUEL_SUPPORTED_CLASSES.include?(clazz)
    end

    # create a table using row data, if it has not been created
    def create_table_if_needed(row)
      unless @table_created
        create_columns = columns_with_row(row)
        database.create_table(table_name.to_sym) do
          create_columns.each do |name, clazz|
            column name.to_sym, clazz
          end
        end
        @table_created = true
      end
    end

    # find the columns of a table via a row of data
    def columns_with_row(row)
      columns = {}
      row.each do |name, value|
        clazz = value.class
        if class_supported?(clazz)
          columns[name] = value.class
        else
          raise ArgumentError, "#{name} is a #{clazz}, not a supported class. Only following classes are supported: #{SEQUEL_SUPPORTED_CLASSES}"
        end
      end
      columns
    end

  end
end