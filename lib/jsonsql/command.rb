require 'claide'
require_relative './importer'
require 'pry'

module Jsonsql
  class Command < CLAide::Command
    self.description = 'Execute SQL against set of JSON files'
    self.command = 'jsonsql'
    self.arguments = '[JSON_FILE] ...'

    def self.options
      [
        ['--console', 'After all commands are run, open pry console with this data'],
        ['--save-to=[filename]', 'If set, sqlite3 db is left on disk at this path'],
        ['--table-name=[table]', 'Override the default table name (table)']
      ].concat(super)
    end

    def initialize(argv)
      @jsons = []

      while argument = argv.shift_argument
        @jsons << argument
      end

      @console = argv.flag?('console', true)
      @filename = argv.option('save-to') || ':memory:'
      @table_name = argv.option('table-name') || 'table'
      super
    end

    def validate!
      super
      if @jsons.size == 0
        help! "At least one JSON files is required."
      end
    end

    def run
      sequel = Sequel.sqlite(@filename)
      importer = Importer.new(database: sequel, table_name: @table_name)
      importer.import @jsons

      if @console
        importer.database.pry
      end
    end
  end
end