require "net/http"
require "json"

class Weather
  include ActiveModel::Model

  attr_reader :location, :data, :cache_hit, :zip

  def initialize(location)
    @location = location
    @cache_hit = true
    @zip = nil
    @data = fetch_weather_data
  end

  private

  def fetch_weather_data
    if location.match?(/^\d{5}$/)
      @zip = location
      found_location = ZipCodes.identify(location)
      @location = "#{found_location[:city]}, #{found_location[:state_name]}"
      coordinates = Geocoder.search(@location).first.coordinates
    else
      coordinates = Geocoder.search(location).first.coordinates
      @zip = Geocoder.search(coordinates).first.postal_code
    end

    Rails.cache.fetch("weather_data/#{@zip}", expires_in: 30.minutes) do
      @cache_hit = false
      lat, lon = coordinates
      api_token = Rails.application.credentials.dig(:weather_api)
      url = URI("https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&exclude=minutely,hourly,daily,alerts&appid=#{api_token}")

      response = Net::HTTP.get(url)
      JSON.parse(response)
    end
  end
end
