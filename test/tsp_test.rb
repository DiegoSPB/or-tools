require_relative "test_helper"

class TSPTest < Minitest::Test
  def test_works
    locations = [
      {name: "Tokyo", latitude: 35.6762, longitude: 139.6503},
      {name: "Delhi", latitude: 28.7041, longitude: 77.1025},
      {name: "Shanghai", latitude: 31.2304, longitude: 121.4737},
      {name: "São Paulo", latitude: -23.5505, longitude: -46.6333},
      {name: "Mexico City", latitude: 19.4326, longitude: -99.1332},
      {name: "Cairo", latitude: 30.0444, longitude: 31.2357},
      {name: "Mumbai", latitude: 19.0760, longitude: 72.8777},
      {name: "Beijing", latitude: 39.9042, longitude: 116.4074},
      {name: "Dhaka", latitude: 23.8103, longitude: 90.4125},
      {name: "Osaka", latitude: 34.6937, longitude: 135.5023},
      {name: "New York City", latitude: 40.7128, longitude: -74.0060},
      {name: "Karachi", latitude: 24.8607, longitude: 67.0011},
      {name: "Buenos Aires", latitude: -34.6037, longitude: -58.3816},
      {name: "Chongqing", latitude: 29.4316, longitude: 106.9123},
      {name: "Istanbul", latitude: 41.0082, longitude: 28.9784},
      {name: "Kolkata", latitude: 22.5726, longitude: 88.3639},
      {name: "Manila", latitude: 14.5995, longitude: 120.9842},
      {name: "Lagos", latitude: 6.5244, longitude: 3.3792},
      {name: "Rio de Janeiro", latitude: -22.9068, longitude: -43.1729},
      {name: "Tianjin", latitude: 39.3434, longitude: 117.3616},
      {name: "Kinshasa", latitude: -4.4419, longitude: 15.2663},
      {name: "Guangzhou", latitude: 23.1291, longitude: 113.2644}
    ]
    tsp = ORTools::TSP.new(locations: locations)
    expected_route = ["Tokyo", "Osaka", "Tianjin", "Beijing", "Shanghai", "Manila", "Guangzhou", "Chongqing", "Dhaka", "Kolkata", "Delhi", "Mumbai", "Karachi", "Istanbul", "Cairo", "Kinshasa", "Lagos", "Rio de Janeiro", "São Paulo", "Buenos Aires", "Mexico City", "New York City", "Tokyo"]
    assert_equal expected_route, tsp.route.map { |r| r[:name] }
    assert_equal expected_route, locations.values_at(*tsp.route_indexes).map { |r| r[:name] }
    assert_equal tsp.distances.sum, tsp.total_distance
  end

  def test_no_locations
    error = assert_raises(ArgumentError) do
      ORTools::TSP.new(locations: [])
    end
    assert_equal "Must be at least two locations", error.message
  end

  def test_single_location
    error = assert_raises(ArgumentError) do
      ORTools::TSP.new(locations: [])
    end
    assert_equal "Must be at least two locations", error.message
  end

  def test_invalid_location
    error = assert_raises(ArgumentError) do
      ORTools::TSP.new(locations: [{name: "Tokyo"}])
    end
    assert_equal "Locations must have latitude and longitude", error.message
  end

  def test_invalid_latitude
    error = assert_raises(ArgumentError) do
      ORTools::TSP.new(locations: [{latitude: 91, longitude: 0}])
    end
    assert_equal "Latitude must be between -90 and 90", error.message
  end

  def test_invalid_longitude
    error = assert_raises(ArgumentError) do
      ORTools::TSP.new(locations: [{latitude: 0, longitude: 181}])
    end
    assert_equal "Longitude must be between -180 and 180", error.message
  end

  def test_last_is_ending_destination
    locations = [
      {name: "Tokyo", latitude: 35.6762, longitude: 139.6503},
      {name: "Delhi", latitude: 28.7041, longitude: 77.1025},
      {name: "Shanghai", latitude: 31.2304, longitude: 121.4737},
      {name: "São Paulo", latitude: -23.5505, longitude: -46.6333},
      {name: "Mexico City", latitude: 19.4326, longitude: -99.1332},
      {name: "Cairo", latitude: 30.0444, longitude: 31.2357},
      {name: "Mumbai", latitude: 19.0760, longitude: 72.8777},
      {name: "Beijing", latitude: 39.9042, longitude: 116.4074},
      {name: "Dhaka", latitude: 23.8103, longitude: 90.4125},
      {name: "Osaka", latitude: 34.6937, longitude: 135.5023},
      {name: "New York City", latitude: 40.7128, longitude: -74.0060},
      {name: "Karachi", latitude: 24.8607, longitude: 67.0011},
      {name: "Buenos Aires", latitude: -34.6037, longitude: -58.3816},
      {name: "Chongqing", latitude: 29.4316, longitude: 106.9123},
      {name: "Istanbul", latitude: 41.0082, longitude: 28.9784},
      {name: "Kolkata", latitude: 22.5726, longitude: 88.3639},
      {name: "Manila", latitude: 14.5995, longitude: 120.9842},
      {name: "Lagos", latitude: 6.5244, longitude: 3.3792},
      {name: "Rio de Janeiro", latitude: -22.9068, longitude: -43.1729},
      {name: "Tianjin", latitude: 39.3434, longitude: 117.3616},
      {name: "Kinshasa", latitude: -4.4419, longitude: 15.2663},
      {name: "Guangzhou", latitude: 23.1291, longitude: 113.2644}
    ]
    tsp = ORTools::TSP.new(locations: locations, round_trip: false)

    expected_route = ["Tokyo", "Osaka", "New York City", "Mexico City", "Buenos Aires", "São Paulo", "Rio de Janeiro", "Lagos", "Kinshasa", "Cairo", "Istanbul", "Karachi", "Mumbai", "Delhi", "Kolkata", "Dhaka", "Chongqing", "Beijing", "Tianjin", "Shanghai", "Manila", "Guangzhou"]

    assert_equal expected_route, tsp.route.map { |r| r[:name] }
    assert_equal expected_route, locations.values_at(*tsp.route_indexes).map { |r| r[:name] }
    assert_equal tsp.distances.sum, tsp.total_distance
  end
end
