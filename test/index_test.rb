require 'test_helper'

class IndexTest < Minitest::Test
  def setup
    @conn = ActiveRecord::Base.connection
    @conn.execute("DROP TABLE IF EXISTS movies")
  end

  def teardown
    @conn.execute("DROP TABLE IF EXISTS movies")
  end

  def test_index_creation
    ActiveRecord::Migration.create_table :movies do |t|
      t.column :movie_embedding, :real, array: true
    end
    @conn.execute("INSERT INTO movies (movie_embedding) VALUES ('{0,1,0}'), ('{3,2,4}')")

    ActiveRecord::Migration.add_index :movies, :movie_embedding, using: :lantern_hnsw, opclass: :dist_l2sq_ops, name: 'movie_embedding_index1'
    assert_index_exists('movie_embedding_index1')

    @conn.execute(<<-SQL)
      CREATE INDEX movie_embedding_index2 
      ON movies USING lantern_hnsw (movie_embedding dist_l2sq_ops) 
      WITH (ef = 15)
    SQL
    assert_index_exists('movie_embedding_index2')
  end

  private

  def assert_index_exists(index_name)
    index_exists = @conn.select_value(<<-SQL)
      SELECT EXISTS (
        SELECT 1
        FROM pg_indexes
        WHERE indexname = '#{index_name}'
      )
    SQL
    assert index_exists, "Index #{index_name} was not created successfully"
  end
end