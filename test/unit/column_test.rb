require "minitest/autorun"

require "insertica/column"

class TestColumn < Minitest::Test
  include Insertica

  def test_string_columns_are_escaped
    column = Column.new("test", ["test", "\n", "\t", "\""]).finalize
    assert_equal ["test", "\\\n", "\\\t", "\\\""], column.values
  end
end