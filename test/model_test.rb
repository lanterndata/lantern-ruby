require "test_helper"

class Item < ActiveRecord::Base
  has_neighbors :embedding
end

class LanternTest < Minitest::Test
  def setup
    @conn = ActiveRecord::Base.connection

    @conn.execute "DROP TABLE IF EXISTS items"
    @conn.execute <<~SQL
      CREATE TABLE items (
        id serial PRIMARY KEY,
        embedding REAL[]
      )
    SQL

    @vectors = [
      [1.0, 0.0, 0.0],
      [0.0, 1.0, 0.0],
      [0.0, 0.0, 1.0]
    ]

    @vectors.each do |vector|
      @conn.execute "INSERT INTO items (embedding) VALUES (ARRAY#{vector})"
    end
  end

  def test_instance_nearest_neighbors
    item = Item.first
    neighbors = item.nearest_neighbors(:embedding).limit(2)
  
    assert_equal 2, neighbors.length
    assert_equal [2, 3], neighbors.pluck(:id)

    distances = neighbors.map { |neighbor| neighbor.distance }
    expected_distances = [2.0, 2.0]
    assert_equal expected_distances, distances
  end
  
  def test_class_nearest_neighbors
    neighbors = Item.nearest_neighbors(:embedding, [0.5, 0.0, 0.5]).limit(2)

    assert 2, neighbors.length
    assert_equal [1, 3], neighbors.pluck(:id)

    distances = neighbors.map { |neighbor| neighbor.distance }
    expected_distances = [0.5, 0.5]
    assert_equal expected_distances, distances
  end

  def test_invalid_dimensions
    assert_raises(ActiveRecord::StatementInvalid) do
      Item.nearest_neighbors(:embedding, [1.0, 0.0]).limit(2).to_a
    end
  end

  def teardown
    @conn.execute "DROP TABLE IF EXISTS items"
  end
end
