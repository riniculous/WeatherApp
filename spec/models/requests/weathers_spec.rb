require "rails_helper"

RSpec.describe "Weathers", type: :request do  describe "GET #index" do
    let(:portland_weather_api_response) do
      { "coord" => { "lon" => -96.7969, "lat" => 32.7763 },
       "weather" => [ { "id" => 800, "main" => "Clear", "description" => "clear sky", "icon" => "01n" } ],
      "base" => "stations", "main" => { "temp" => 281.07, "feels_like" => 279.46, "temp_min" => 279.23,
      "temp_max" => 282.82, "pressure" => 1019, "humidity" => 75, "sea_level" => 1019, "grnd_level" => 1000 },
       "visibility" => 10000, "wind" => { "speed" => 2.57, "deg" => 210 },
      "clouds" => { "all" => 0 }, "dt" => 1744101444,
      "sys" => { "type" => 2, "id" => 2036480, "country" => "US", "sunrise" => 1744113937, "sunset" => 1744159910 },
      "timezone" => -18000, "id" => 4684888, "name" => "Portland", "cod" => 200 }
    end

    let(:dallas_weather_api_response) do
      { "coord" => { "lon" => -96.7969, "lat" => 32.7763 },
       "weather" => [ { "id" => 800, "main" => "Clear", "description" => "clear sky", "icon" => "01n" } ],
      "base" => "stations", "main" => { "temp" => 281.07, "feels_like" => 279.46, "temp_min" => 279.23,
      "temp_max" => 282.82, "pressure" => 1019, "humidity" => 75, "sea_level" => 1019, "grnd_level" => 1000 },
       "visibility" => 10000, "wind" => { "speed" => 2.57, "deg" => 210 },
      "clouds" => { "all" => 0 }, "dt" => 1744101444,
      "sys" => { "type" => 2, "id" => 2036480, "country" => "US", "sunrise" => 1744113937, "sunset" => 1744159910 },
      "timezone" => -18000, "id" => 4684888, "name" => "Dallas", "cod" => 200 }
    end

    it "creates a Weather object with the provided location" do
      # Mock the Weather class
      weather_mock = instance_double("Weather", data: portland_weather_api_response, cache_hit: false, zip: "97201")
      expect(Weather).to receive(:new).with("Portland, Oregon").and_return(weather_mock)

      # Perform the request
      get weathers_path, params: { location: "Portland, Oregon" }

      expect(response.body).to include("Portland")

      expect(response).to render_template("index")
    end

    it "creates a Weather object with the default location when no location is provided" do
      # Mock the Weather class
      weather_mock = instance_double("Weather", data: dallas_weather_api_response, cache_hit: true, zip: "75001")
      expect(Weather).to receive(:new).with("Dallas, Texas").and_return(weather_mock)

      # Perform the request
      get weathers_path

      expect(response.body).to include("Dallas")

      expect(response).to render_template("index")
    end
  end
end
