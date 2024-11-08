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
      [0.0, 0.5, 0.0],
      [1.0, 0.0, 0.2]
    ]

    @vectors.each do |vector|
      @conn.execute "INSERT INTO items (embedding) VALUES (ARRAY#{vector})"
    end
  end

  # Helper method to test nearest neighbors
  def assert_nearest_neighbors(test_case)
    item = Item.find(test_case[:item_id])
    neighbors = item.nearest_neighbors(:embedding, distance: test_case[:distance_metric]).limit(2)

    assert_equal test_case[:expected_neighbor_ids], neighbors.pluck(:id)
    distances = neighbors.map(&:distance)

    test_case[:expected_distances].each_with_index do |expected_distance, index|
      if expected_distance.is_a?(Float)
        assert_in_delta expected_distance, distances[index], 1e-6, "Distance mismatch for neighbor #{neighbors[index].id}"
      else
        assert_equal expected_distance, distances[index], "Distance mismatch for neighbor #{neighbors[index].id}"
      end
    end
  end

  # Test cases for different distance metrics
  DISTANCE_TEST_CASES = [
    {
      description: "L2 Distance (instance method)",
      item_id: 1,
      distance_metric: 'l2',
      expected_neighbor_ids: [3, 2],
      expected_distances: [0.04, 1.25]
    },
    {
      description: "Cosine Distance (instance method)",
      item_id: 1,
      distance_metric: 'cosine',
      expected_neighbor_ids: [3, 2],
      expected_distances: [0.0194193243, 1.0]
    }
  ]

  # Dynamically define test methods for instance methods
  DISTANCE_TEST_CASES.each_with_index do |test_case, index|
    define_method("test_instance_nearest_neighbors_#{test_case[:distance_metric]}") do
      assert_nearest_neighbors(test_case)
    end
  end

  # Similar helper method for class methods
  def assert_class_nearest_neighbors(test_case)
    neighbors = Item.nearest_neighbors(:embedding, test_case[:query_vector], distance: test_case[:distance_metric]).limit(2)

    assert_equal test_case[:expected_neighbor_ids], neighbors.pluck(:id)
    distances = neighbors.map(&:distance)

    test_case[:expected_distances].each_with_index do |expected_distance, index|
      if expected_distance.is_a?(Float)
        assert_in_delta expected_distance, distances[index], 1e-6, "Distance mismatch for neighbor #{neighbors[index].id}"
      else
        assert_equal expected_distance, distances[index], "Distance mismatch for neighbor #{neighbors[index].id}"
      end
    end
  end

  # Test cases for class methods
  CLASS_DISTANCE_TEST_CASES = [
    {
      description: "L2 Distance (class method)",
      query_vector: [0.5, 0.0, 0.2],
      distance_metric: 'l2',
      expected_neighbor_ids: [3, 1],
      expected_distances: [0.25, 0.29]
    },
    {
      description: "Cosine Distance (class method)",
      query_vector: [0.5, 0.0, 0.2],
      distance_metric: 'cosine',
      expected_neighbor_ids: [3, 1],
      expected_distances: [0.01671799501, 0.07152330911]
    }
  ]

  # Dynamically define test methods for class methods
  CLASS_DISTANCE_TEST_CASES.each_with_index do |test_case, index|
    define_method("test_class_nearest_neighbors_#{test_case[:distance_metric]}") do
      assert_class_nearest_neighbors(test_case)
    end
  end

  def test_invalid_dimensions
    assert_raises(ActiveRecord::StatementInvalid) do
      Item.nearest_neighbors(:embedding, [1.0, 0.0], distance: 'l2').limit(2).to_a
    end
  end

  def teardown
    @conn.execute "DROP TABLE IF EXISTS items"
  end
end
