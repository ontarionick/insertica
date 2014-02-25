require 'insertica/column'

require 'json/ext'
require 'vertica'

module Insertica
  class Table
    attr_accessor :schema_name
    attr_accessor :table_name

    def initialize(schema_name, filename)
      @filename    = filename
      @schema_name = schema_name
      @table_name  = File.basename(filename, '.*')
      @file        = File.read(@filename)

      columns and rows
    end

    def full_name
      "#{schema_name}.#{table_name}"
    end

    def definition
      @definition ||= @columns.values.map { |column| "#{column.definition}" }.join(",\n")
    end

    def filler_definition
      @filler_definition ||= [
        @columns.values.map { |column| "#{column.filler_definition}" }.join(",\n"),
        @columns.values.map { |column| "#{column.fix_nulls_definition}" }.join(",\n")
      ].join(",\n")
    end

    def insert(**options)
      vertica_connection = Vertica.connect({
        host:     options[:host],
        user:     options[:user],
        password: options[:password],
        port:     options[:port]
      })

      drop_statement   = "DROP TABLE IF EXISTS #{full_name} CASCADE"
      create_statement = "CREATE TABLE #{full_name} (#{definition})"
      copy_statement   = "COPY #{full_name} (#{filler_definition}) FROM STDIN DELIMITER '\t' ENCLOSED BY '\"' NULL AS 'NULL' ABORT ON ERROR"

      vertica_connection.query(drop_statement)
      vertica_connection.query(create_statement)
      vertica_connection.copy(copy_statement) do |stdin|
        stdin << to_tsv
      end
      vertica_connection.query("COMMIT")
    end

    def rows
      @rows ||= generate_rows
    end

    def columns
      @columns ||= generate_columns
    end

    def to_tsv
      @rows.map do |row|
        "\"#{row.join("\"\t\"")}\"\n"
      end.join("")
    end

    private

    def generate_columns
      columns = {}
      @numer_of_rows = @file.lines.length

      @file.lines.each_with_index do |line, index|
        json_line = JSON.parse(line)
        json_line.keys.each do |key|
          columns[key] = Column.new(key) if columns[key].nil?
          columns[key].values[index] = json_line[key]
        end
      end
      columns.each { |key, column| column.finalize }
      columns
    end

    def generate_rows
      rows = []
      @numer_of_rows.times do |i|
        row = []
        @columns.values.each do |column|
          row << column.values[i]
        end
        rows << row
      end
      rows
    end
  end
end