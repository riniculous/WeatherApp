require "json"

class WeathersController < ApplicationController
  def index
    location = params[:location] || "Dallas, Texas"
    weather = Weather.new(location)
    render "index", locals: { weather_data: weather.data, cache_hit: weather.cache_hit, zip: weather.zip }
  end
end
