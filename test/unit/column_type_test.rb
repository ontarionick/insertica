require "minitest/autorun"

require "insertica/column_type"

class TestColumnType < Minitest::Test
  include Insertica

  def test_column_of_strings_becomes_varchar
    assert_equal "VARCHAR", ColumnType.new(['a', 'b', 'c']).to_s
  end

  def test_column_of_strings_with_nil_becomes_varchar
    assert_equal "VARCHAR", ColumnType.new([nil, 'b', nil]).to_s
  end

  def test_column_of_string_with_integers_becomes_varchar
    assert_equal "VARCHAR", ColumnType.new([1, 'b', 3]).to_s
  end

  def test_column_of_integers_becomes_integer
    assert_equal "INTEGER", ColumnType.new([1, 2, 3]).to_s
  end

  def test_column_of_integers_with_nil_becomes_integer
    assert_equal "INTEGER", ColumnType.new([nil, 2, nil]).to_s
  end

  def test_column_of_floats_becomes_float
    assert_equal "FLOAT", ColumnType.new([1.1, 2.2, 3.3]).to_s
  end

  def test_column_of_floats_with_nil_becomes_float
    assert_equal "FLOAT", ColumnType.new([nil, 2.2, nil]).to_s
  end

  def test_column_of_floats_with_integer_becomes_float
    assert_equal "FLOAT", ColumnType.new([1, 2.2, 3]).to_s
  end

  def test_column_of_booleans_becomes_boolean
    assert_equal "BOOLEAN", ColumnType.new([true, false, true]).to_s
  end

  def test_column_of_booleans_with_nil_becomes_boolean
    assert_equal "BOOLEAN", ColumnType.new([nil, true, false, nil]).to_s
  end

  def test_column_of_booleans_with_strings_becomes_varchar
    assert_equal "VARCHAR", ColumnType.new(['true', true, false, 'false']).to_s
  end

  def test_column_of_nils_becomes_varchar
    assert_equal "VARCHAR", ColumnType.new([nil, nil, nil]).to_s
  end
end