require "rails_helper"

RSpec.describe Weather, type: :model do
  let(:zip_code) { "97201" }
  let(:location) { "Portland, Oregon" }
  let(:coordinates) { [ 45.5202, -122.6742 ] }
  let(:weather_api_response) do
    { "coord" => { "lon" => -96.7969, "lat" => 32.7763 },
    "weather" => [ { "id" => 800, "main" => "Clear", "description" => "clear sky", "icon" => "01n" } ],
   "base" => "stations", "main" => { "temp" => 281.07, "feels_like" => 279.46, "temp_min" => 279.23,
   "temp_max" => 282.82, "pressure" => 1019, "humidity" => 75, "sea_level" => 1019, "grnd_level" => 1000 },
    "visibility" => 10000, "wind" => { "speed" => 2.57, "deg" => 210 },
   "clouds" => { "all" => 0 }, "dt" => 1744101444,
   "sys" => { "type" => 2, "id" => 2036480, "country" => "US", "sunrise" => 1744113937, "sunset" => 1744159910 },
   "timezone" => -18000, "id" => 4684888, "name" => "Portland", "cod" => 200 }
  end

  before do
    allow(Geocoder).to receive(:search).and_return([ double(coordinates: coordinates, postal_code: zip_code) ])
    allow(ZipCodes).to receive(:identify).and_return({ city: "Portland", state_name: "Oregon" })
    allow(Rails.cache).to receive(:fetch).and_call_original
  end

  describe "#initialize" do
    context "when location is a 5-digit ZIP code" do
      it "calls ZipCodes.identify with the ZIP code" do
        expect(ZipCodes).to receive(:identify).with(zip_code).and_return({ city: "Portland", state_name: "Oregon" })
        Weather.new(zip_code)
      end
    end

    context "when location is not a 5-digit ZIP code" do
      it "calls Geocoder.search with the location" do
        expect(Geocoder).to receive(:search).with(location).and_return([ double(coordinates: coordinates) ])
        Weather.new(location)
      end

      it "manually sets the ZIP code from Geocoder results" do
        weather = Weather.new(location)
        expect(weather.zip).to eq(zip_code)
      end
    end
  end

  describe "caching behavior" do
    context "when there is a cache hit" do
      it "does not call the API and sets cache_hit to true" do
        allow(Rails.cache).to receive(:fetch).and_return(weather_api_response)
        weather = Weather.new(location)
        expect(weather.cache_hit).to be true
        expect(weather.data).to eq(weather_api_response)
      end
    end

    context "when there is a cache miss" do
      it "calls the API and sets cache_hit to false" do
        allow(Rails.cache).to receive(:fetch).and_yield
        allow(Net::HTTP).to receive(:get).and_return(weather_api_response.to_json)

        weather = Weather.new(location)

        expect(weather.cache_hit).to be false
        expect(weather.data).to eq(weather_api_response)
      end
    end
  end
end
