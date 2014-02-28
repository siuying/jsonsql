require 'sequel'
require 'json'
require 'pry'

module Jsonsql
  class Importer
    SEQUEL_SUPPORTED_CLASSES = [Integer, String, Fixnum, Bignum, Float, BigDecimal, Date, DateTime, Time, Numeric, TrueClass, FalseClass]

    attr_reader :database, :table, :table_name

    def initialize(json_path, database=Sequel.sqlite, table_name="table")
      @json_path = json_path
      @table_name = table_name
      @database  = database
    end

    def table
      @table ||= @database[table_name.to_sym]
    end

    def import_path(json_path)
      Dir["#{json_path}/*.json"].each do |filename|
        import_jsonfile(filename)
      end
    end

    def import_jsonfile(filename)
      row = JSON.parse(open(filename).read)
      create_table_if_needed(row)
      table.insert(row)
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

    private
    def class_supported?(clazz)
      SEQUEL_SUPPORTED_CLASSES.include?(clazz)
    end

    def create_table_if_needed(row)
      create_columns = columns_with_row(row)
      database.create_table(table_name.to_sym) do
        create_columns.each do |name, clazz|
          column name.to_sym, clazz
        end
      end
    end
  end
end