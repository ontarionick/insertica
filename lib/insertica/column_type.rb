require 'date'

module Insertica
  class ColumnType
    attr_accessor :vertica_type

    DATETIME_TYPE  = 'TIMESTAMP'
    TRUECLASS_TYPE = 'BOOLEAN'
    INTEGER_TYPE   = 'INTEGER'
    FLOAT_TYPE     = 'FLOAT'
    STRING_TYPE    = 'VARCHAR'

    def initialize(values = [])
      @vertica_type = guess_type(values)
    end

    def to_s
      @vertica_type
    end

    def needs_escaping?
      STRING_TYPE == @vertica_type
    end

    private

    def guess_type(values)
      if all_nil?(values)
        STRING_TYPE
      elsif datetime?(values)
        DATETIME_TYPE
      elsif trueclass?(values)
        TRUECLASS_TYPE
      elsif integer?(values)
        INTEGER_TYPE
      elsif float?(values)
        FLOAT_TYPE
      else 
        STRING_TYPE
      end
    end

    def all_nil?(values)
      values.all? { |value| value.nil? }
    end

    def datetime?(values)
      values.all? do |value|
        value.nil? || !!DateTime.iso8601(value)
      end
    rescue
      false
    end

    def trueclass?(values)
      values.all? do |value|
        value.nil? || value.class == FalseClass || value.class == TrueClass 
      end
    end

    def integer?(values)
      values.all? do |value|
        value.nil? || Integer(value) == Float(value)
      end
    rescue
      false
    end

    def float?(values)
      values.all? do |value|
        value.nil? || !!Float(value)
      end
    rescue
      false
    end
  end
end