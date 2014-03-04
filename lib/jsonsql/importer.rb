require 'sequel'
require 'json'

module Jsonsql
  class Importer
    SEQUEL_SUPPORTED_CLASSES = [Integer, String, Fixnum, Bignum, Float, BigDecimal, Date, DateTime, Time, Numeric, TrueClass, FalseClass]

    attr_reader :database, :table_name, :transformer

    def initialize(database: Sequel.sqlite, table_name: "table", transformer: nil)
      @table_name = table_name
      @database   = database
      @transformer = transformer
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
      rowOrArrayOfRows = JSON.parse(open(filename).read)
      if rowOrArrayOfRows.is_a?(Array)
        rowOrArrayOfRows.each do |row|
          import_row(row)
        end
      elsif rowOrArrayOfRows.is_a?(Hash)
        import_row(rowOrArrayOfRows)
      else
        raise "Cannot import #{filename}, JSON file should contains Array or Hash."
      end
    end

    def self.class_supported?(clazz)
      SEQUEL_SUPPORTED_CLASSES.include?(clazz)
    end

    private
    def import_row(row)
      row = transformer.transform(row) if transformer

      # filter to only supported fields
      row = row.select { |k, v| Jsonsql::Importer.class_supported?(v.class) }

      create_table_if_needed(row)
      table.insert(row)
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
        if self.class.class_supported?(clazz)
          columns[name] = value.class
        else
          $stderr.puts "Class #{clazz} not supported, skipped"
        end
      end
      columns
    end

  end
end