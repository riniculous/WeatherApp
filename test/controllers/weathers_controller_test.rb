require "test_helper"

class WeathersControllerTest < ActionDispatch::IntegrationTest
  test "should get index with valid location" do
    # Mock Geocoder response
    Geocoder::Lookup::Test.add_stub(
      "Portland, Oregon", [
        Geocoder::Result::Test.new("coordinates" => [ 32.7767, -96.7970 ])
      ]
    )

    # Stub API response
    weather_api_response =  { "coord" => { "lon" => -122.6742, "lat" => 45.5202 }, "weather" => [ { "id" => 804, "main" => "Clouds", "description" => "overcast clouds", "icon" => "04n" } ], "base" => "stations", "main" => { "temp" => 283.02, "feels_like" => 282, "temp_min" => 281.93, "temp_max" => 283.96, "pressure" => 1016, "humidity" => 83, "sea_level" => 1016, "grnd_level" => 1006 }, "visibility" => 10000, "wind" => { "speed" => 2.24, "deg" => 219, "gust" => 8.05 }, "clouds" => { "all" => 100 }, "dt" => 1744089199, "sys" => { "type" => 2, "id" => 2008548, "country" => "US", "sunrise" => 1744033131, "sunset" => 1744080369 }, "timezone" => -25200, "id" => 5746545, "name" => "Portland", "cod" => 200 }.to_json

    stub_request(:get, /api.openweathermap.org/).to_return(status: 200, body: weather_api_response)
    stub_request(:get, "https://nominatim.openstreetmap.org/search?accept-language=en&addressdetails=1&format=json&q=Dallas,%20Texas").
  with(
    headers: {
    "Accept"=>"*/*",
    "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
    "User-Agent"=>"Ruby"
    }).
  to_return(status: 200, body: { "lon" => -96.7970, "lat" => 32.7767 }.to_json, headers: {})
    # Perform the request
    get weathers_path, params: { location: "Dallas, Texas" }

    # Assertions
    assert_response :success
    assert_match "Portland", @response.body
    assert_match "Clouds", @response.body
  end

  test "should get index with default location" do
    # Mock Geocoder response for default location
    Geocoder::Lookup::Test.add_stub(
      "Dallas, Texas", [
        Geocoder::Result::Test.new("coordinates" => [ 45.5202,  -122.6742 ])
      ]
    )

    # Stub API response
    weather_api_response =  { "coord" => { "lon" => -122.6742, "lat" => 45.5202 }, "weather" => [ { "id" => 804, "main" => "Clear", "description" => "overcast clouds", "icon" => "04n" } ], "base" => "stations", "main" => { "temp" => 283.02, "feels_like" => 282, "temp_min" => 281.93, "temp_max" => 283.96, "pressure" => 1016, "humidity" => 83, "sea_level" => 1016, "grnd_level" => 1006 }, "visibility" => 10000, "wind" => { "speed" => 2.24, "deg" => 219, "gust" => 8.05 }, "clouds" => { "all" => 100 }, "dt" => 1744089199, "sys" => { "type" => 2, "id" => 2008548, "country" => "US", "sunrise" => 1744033131, "sunset" => 1744080369 }, "timezone" => -25200, "id" => 5746545, "name" => "Dallas", "cod" => 200 }.to_json
    stub_request(:get, "https://nominatim.openstreetmap.org/search?accept-language=en&addressdetails=1&format=json&q=Dallas,%20Texas").
    with(
    headers: {
    "Accept"=>"*/*",
    "Accept-Encoding"=>"gzip;q=1.0,deflate;q=0.6,identity;q=0.3",
    "User-Agent"=>"Ruby"
    }).
    to_return(status: 200, body: { "lon" => -96.7970, "lat" => 32.7767 }.to_json, headers: {})

    stub_request(:get, "/api.openweathermap.org/")

    stub_request(:get, /api.openweathermap.org/).to_return(status: 200, body: weather_api_response)

    # Perform the request without location
    get weathers_path

    # Assertions
    assert_response :success
    assert_match "Dallas", @response.body
    assert_match "Clear", @response.body
  end
end
