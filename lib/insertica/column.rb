require 'insertica/column_type'

module Insertica
  class Column
    ESCAPE_CHARACTERS = ["\n", "\t", "\""]

    attr_accessor :name
    attr_accessor :values
    attr_accessor :type

    def initialize(name, values = [])
      @name   = name
      @type   = nil
      @values = values
    end

    def finalize
      @type = ColumnType.new(@values)
      escape_strings if @type.needs_escaping?

      self
    end

    def definition
      "#{@name} #{@type}"
    end

    def filler_definition
      "#{@name}_filler FILLER VARCHAR"
    end

    def fix_nulls_definition
      "#{@name} AS CASE WHEN #{@name}_filler = '' THEN NULL ELSE #{@name}_filler::#{@type} END"
    end

    private

    def escape_strings
      ESCAPE_CHARACTERS.each { |character| @values.map! { |value| value.gsub("#{character}","\\#{character}") unless value.nil? } }
    end
  end
end