# WeatherApp

WeatherApp is a simple Ruby on Rails application that provides weather information for a given location. It uses data from OpenWeatherMap and geolocation services from the Geocoder gem. The application caches weather data for each city and state combination for 30 minutes to improve performance and reduce API calls.

---

## Features

- Fetches **current weather information** from [OpenWeatherMap](https://openweathermap.org/).
- Uses **Geocoder gem** to convert city and state into geographic coordinates.
- Caches weather data for **30 minutes** per city and state to optimize API usage.
- Displays weather details such as temperature, humidity, wind speed, and more.

---

## Setup Instructions

1. Clone the repository:
   ```bash
   git clone <repository-url>
   cd WeatherApp
   ```

2. Install dependencies:
   ```bash
   bin/setup
   ```

3. Install Gems
  ```bundle install```

4. Start the development server:
   ```bash
   bin/dev
   ```

5. Run tests:
   ```bash
   rails test
   ```

---

## API Keys

The application uses an API key for OpenWeatherMap, which is securely stored using Rails credentials. Ensure you have the API key set up in your Rails credentials file:

```yaml
weather_api: YOUR_OPENWEATHERMAP_API_KEY
```

---

## Caching

Weather data is cached for **30 minutes** per city and state combination using Rails' built-in caching mechanism. This reduces the number of API calls and improves performance.
![Home Page](placeholder-image-1.png)


---

## Dependencies

- **Ruby on Rails**: The web framework used to build the application.
- **Geocoder Gem**: Converts city and state into geographic coordinates.
- **OpenWeatherMap API**: Provides weather data.

---

## Running Tests

To ensure everything is working correctly, run the test suite:

```bash
rails test
```

This will execute all the tests for the application.

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

* ...
