require "net/http"
require "json"

class WeathersController < ApplicationController
  def index
    location = params[:location] || "Dallas, Texas"
    cache_hit = true
    weather_data = Rails.cache.fetch("weather_data/#{location}", expires_in: 30.minutes) do
      cache_hit = false
      coordinates = Geocoder.search(location).first.coordinates
      lat, lon = coordinates
      api_token = Rails.application.credentials.dig(:weather_api)
      url = URI("https://api.openweathermap.org/data/2.5/weather?lat=#{lat}&lon=#{lon}&exclude=minutely,hourly,daily,alerts&appid=#{api_token}")

      response = Net::HTTP.get(url)
      JSON.parse(response)
    end
    render "index", locals: { weather_data: weather_data, cache_hit: cache_hit }
  end
end
