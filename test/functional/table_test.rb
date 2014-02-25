require "minitest/autorun"

require "insertica/table"

class TestColumn < Minitest::Test
  include Insertica

  def setup
    @table = Table.new("test_schema", "./test/data/testdata.json")
  end

  def test_table_full_name
    assert_equal "test_schema.testdata", @table.full_name
  end

  def test_columns
    columns = @table.columns
    assert_equal 7, columns.values.length

    assert_equal "INTEGER", columns["id"].type.to_s
    assert_equal "VARCHAR", columns["first_name"].type.to_s
    assert_equal "VARCHAR", columns["last_name"].type.to_s
    assert_equal "BOOLEAN", columns["testing"].type.to_s
    assert_equal "TIMESTAMP", columns["born"].type.to_s
    assert_equal [
      "2000-01-01T15:00:00.000+0000",
      "1990-01-01T15:00:00.000+0000",
      "1980-01-01T15:00:00.000+0000",
      "1970-01-01T15:00:00.000+0000",
      "1960-01-01T15:00:00.000+0000",
      "2010-01-01T15:00:00.000+0000"
    ], columns["born"].values

    assert_equal "INTEGER", columns["money"].type.to_s
    assert_equal "FLOAT", columns["dollaz"].type.to_s
  end

  def test_rows
    rows = @table.rows
    assert_equal 6, rows.length

    assert_equal [1, "foo", "bar", true,  "2000-01-01T15:00:00.000+0000",   5, nil], rows[0]
    assert_equal [2, "foo", "bar", false, "1990-01-01T15:00:00.000+0000",  10, nil], rows[1]
    assert_equal [3, "foo", "bar", true,  "1980-01-01T15:00:00.000+0000",  15, nil], rows[2]
    assert_equal [4, "foo", "bar", false, "1970-01-01T15:00:00.000+0000",  20, nil], rows[3]
    assert_equal [5, "foo", "bar", true,  "1960-01-01T15:00:00.000+0000",  25, nil], rows[4]
    assert_equal [6, "foo", "bar", false, "2010-01-01T15:00:00.000+0000", nil, 5.2], rows[5]
  end

  def test_to_tsv
    tsv = "\"1\"\t\"foo\"\t\"bar\"\t\"true\"\t\"2000-01-01T15:00:00.000+0000\"\t\"5\"\t\"\"\n\"2\"\t\"foo\"\t\"bar\"\t\"false\"\t\"1990-01-01T15:00:00.000+0000\"\t\"10\"\t\"\"\n\"3\"\t\"foo\"\t\"bar\"\t\"true\"\t\"1980-01-01T15:00:00.000+0000\"\t\"15\"\t\"\"\n\"4\"\t\"foo\"\t\"bar\"\t\"false\"\t\"1970-01-01T15:00:00.000+0000\"\t\"20\"\t\"\"\n\"5\"\t\"foo\"\t\"bar\"\t\"true\"\t\"1960-01-01T15:00:00.000+0000\"\t\"25\"\t\"\"\n\"6\"\t\"foo\"\t\"bar\"\t\"false\"\t\"2010-01-01T15:00:00.000+0000\"\t\"\"\t\"5.2\"\n"

    assert_equal tsv, @table.to_tsv
  end

  def test_definition
    definition = "id INTEGER,\nfirst_name VARCHAR,\nlast_name VARCHAR,\ntesting BOOLEAN,\nborn TIMESTAMP,\nmoney INTEGER,\ndollaz FLOAT"
    assert_equal definition, @table.definition
  end

  def test_filler_definition
    definition = "id_filler FILLER VARCHAR,\nfirst_name_filler FILLER VARCHAR,\nlast_name_filler FILLER VARCHAR,\ntesting_filler FILLER VARCHAR,\nborn_filler FILLER VARCHAR,\nmoney_filler FILLER VARCHAR,\ndollaz_filler FILLER VARCHAR,\nid AS CASE WHEN id_filler = '' THEN NULL ELSE id_filler::INTEGER END,\nfirst_name AS CASE WHEN first_name_filler = '' THEN NULL ELSE first_name_filler::VARCHAR END,\nlast_name AS CASE WHEN last_name_filler = '' THEN NULL ELSE last_name_filler::VARCHAR END,\ntesting AS CASE WHEN testing_filler = '' THEN NULL ELSE testing_filler::BOOLEAN END,\nborn AS CASE WHEN born_filler = '' THEN NULL ELSE born_filler::TIMESTAMP END,\nmoney AS CASE WHEN money_filler = '' THEN NULL ELSE money_filler::INTEGER END,\ndollaz AS CASE WHEN dollaz_filler = '' THEN NULL ELSE dollaz_filler::FLOAT END"
    assert_equal definition, @table.filler_definition
  end
end