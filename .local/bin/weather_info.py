#!/usr/bin/env python3
"""
Weather Forecast Script
Author: Vinicius M. Longaray

Fetches weather forecast data from OpenWeather API 2.5.
Shows current weather and daily min/max temperatures for the next few days.
"""

import argparse
import json
import numbers
import os
import sys
import urllib.error
import urllib.parse
import urllib.request
from datetime import datetime
from math import floor


class WeatherAPI:
    """OpenWeather API 2.5 client for fetching weather forecast."""

    BASE_URL = "https://api.openweathermap.org/data/2.5/forecast"
    MAX_COLUMNS = 68
    BORDERS = 2

    def __init__(self, api_key: str):
        """Initialize the weather API client.

        Args:
            api_key: OpenWeather API key
        """
        self.api_key = api_key

    def get_forecast(self, lat: float = None, lon: float = None,
                     city: str = None, units: str = "metric") -> dict:
        """Fetch 5-day forecast data (3-hour intervals).

        Args:
            lat: Latitude coordinate
            lon: Longitude coordinate
            city: City name (alternative to lat/lon)
            units: Units of measurement (standard, metric, imperial)

        Returns:
            Dictionary containing forecast data

        Raises:
            Exception: If the request fails
        """
        params = {
            'appid': self.api_key,
            'units': units
        }

        if city:
            params['q'] = city
        elif lat is not None and lon is not None:
            params['lat'] = lat
            params['lon'] = lon
        else:
            raise ValueError("Must provide either city or lat/lon coordinates")

        query_string = urllib.parse.urlencode(params)
        url = f"{self.BASE_URL}?{query_string}"

        try:
            with urllib.request.urlopen(url) as response:
                data = json.loads(response.read().decode())
                return data
        except urllib.error.HTTPError as e:
            error_msg = e.read().decode() if e.fp else str(e)
            raise Exception(f"HTTP Error {e.code}: {error_msg}")
        except urllib.error.URLError as e:
            raise Exception(f"URL Error: {e.reason}")

    def get_weather_icon(self, condition: str, timestamp: int = None, sunrise: int = None, sunset: int = None, ignore_night: bool = False) -> str:
        """Get weather icon based on condition description and time of day.

        Args:
            condition: Weather condition description
            timestamp: Unix timestamp for the weather data
            sunrise: Unix timestamp for sunrise
            sunset: Unix timestamp for sunset

        Returns:
            Icon string
        """
        condition_lower = condition.lower()

        # Determine if it's night time
        is_night = False
        if timestamp and sunrise and sunset:
            is_night = timestamp < sunrise or timestamp > sunset
        elif timestamp:
            # Fallback: check if hour is between 20:00 and 06:00
            hour = datetime.fromtimestamp(timestamp).hour
            is_night = hour >= 20 or hour < 6

        if 'clear' in condition_lower:
            return '🌙 ' if is_night and not ignore_night else '☀️ '
        elif 'cloud' in condition_lower and 'few' in condition_lower:
            return '☁️ '
        elif 'cloud' in condition_lower:
            return '☁️ '
        elif 'rain' in condition_lower and ('light' in condition_lower or 'drizzle' in condition_lower):
            return '🌧️ '
        elif 'rain' in condition_lower:
            return '🌧️ '
        elif 'thunder' in condition_lower or 'storm' in condition_lower:
            return '⛈️ '
        elif 'snow' in condition_lower:
            return '❄️ '
        elif 'mist' in condition_lower or 'fog' in condition_lower or 'haze' in condition_lower:
            return '🌫️ '
        else:
            return '🌍 '

    def get_formatted_line(self, first: str, second: str, has_second_column: bool, column_width: int) -> str:
        space_first = column_width - len(first.rstrip())
        space_second = column_width - len(second.rstrip()) - 1

        if has_second_column:
            return f"│{first.rstrip()}{' ' * space_first}│{second.rstrip()}{' ' * space_second}│"
        else:
            return f"│{first.rstrip()}{' ' * space_first}│"

    def create_current_weather_summary(self, current: dict, city: dict, sunrise: str, sunset: str, temp_unit: str, speed_unit: str) -> list:
        output = []

        # Location info
        location = city.get('name', 'Unknown')
        country = city.get('country', '')
        if country:
            location = f"{location}, {country}"

        title = f" 🌤️ WEATHER FORECAST - {location}"

        output.append("╭" + "─" * (self.MAX_COLUMNS - self.BORDERS) + "╮")
        output.append("│" + title + " " * (self.MAX_COLUMNS - self.BORDERS - len(title)) + "│")
        output.append("╰" + "─" * (self.MAX_COLUMNS - self.BORDERS) + "╯")

        # Current weather (first entry)
        current_main = current.get('main', {})
        current_weather = current.get('weather', [{}])[0]
        current_wind = current.get('wind', {})
        current_condition = current_weather.get('description', 'N/A')
        current_dt = current.get('dt')

        output.append("")
        output.append("📍 CURRENT WEATHER:")
        output.append(
            f"  🕐 Time: {datetime.fromtimestamp(current_dt).strftime('%Y-%m-%d %H:%M')}")
        output.append(f"  🌡️ Temperature: {current_main.get('temp', 'N/A')}{temp_unit}")
        output.append(f"  🤔 Feels Like: {current_main.get('feels_like', 'N/A')}{temp_unit}")
        output.append(
            f"  {self.get_weather_icon(current_condition, current_dt, sunrise, sunset, False)}Conditions: {current_condition.title()}")
        output.append(f"  💧 Humidity: {current_main.get('humidity', 'N/A')}%")
        output.append(f"  💨 Wind Speed: {current_wind.get('speed', 'N/A')} {speed_unit}")

        return output

    def create_daily_forecast_summary(self, forecast_list: list, sunrise: str, sunset: str, temp_unit: str, speed_unit: str) -> list:
        output = []
        title = " 📅 DAILY FORECAST"

        # Display daily summaries
        output.append("")
        output.append(f"╭{"─" * (self.MAX_COLUMNS - self.BORDERS)}╮")
        output.append(f"│{title}{" " * (self.MAX_COLUMNS - self.BORDERS - len(title) - 1)}│")
        # output.append(f"╰{"─" * (self.MAX_COLUMNS - self.BORDERS)}╯")

        # Organize forecast data
        daily_data = self.organize_forecast_per_date(forecast_list)
        sorted_days = sorted(daily_data.keys())

        # Display in two-column format with all details
        for i in range(0, len(sorted_days), 2):
            # First column (left)
            day_date1 = sorted_days[i]
            day_info1 = daily_data[day_date1]
            temps1 = [t for t in day_info1['temps'] if t is not None]

            if not temps1:
                continue

            min_temp1 = min(temps1)
            max_temp1 = max(temps1)
            avg_temp1 = sum(temps1) / len(temps1)
            conditions1 = [c for c in day_info1['conditions'] if c]
            condition1 = max(set(conditions1), key=conditions1.count) if conditions1 else 'N/A'

            avg_humidity1 = sum(day_info1['humidity']) / \
                len(day_info1['humidity']) if day_info1['humidity'] else 0
            avg_wind1 = sum(day_info1['wind_speed']) / \
                len(day_info1['wind_speed']) if day_info1['wind_speed'] else 0

            day_name1 = day_date1.strftime('%A')
            date_str1 = day_date1.strftime('%Y-%m-%d')
            midday_timestamp1 = int(datetime.combine(
                day_date1, datetime.min.time()).replace(hour=12).timestamp())
            icon1 = self.get_weather_icon(condition1, midday_timestamp1,
                                          sunrise, sunset, True)

            # Second column (right) - if it exists
            has_second_col = False
            if i + 1 < len(sorted_days):
                day_date2 = sorted_days[i + 1]
                day_info2 = daily_data[day_date2]
                temps2 = [t for t in day_info2['temps'] if t is not None]

                if temps2:
                    has_second_col = True
                    min_temp2 = min(temps2)
                    max_temp2 = max(temps2)
                    avg_temp2 = sum(temps2) / len(temps2)
                    conditions2 = [c for c in day_info2['conditions'] if c]
                    condition2 = max(set(conditions2),
                                     key=conditions2.count) if conditions2 else 'N/A'

                    avg_humidity2 = sum(day_info2['humidity']) / \
                        len(day_info2['humidity']) if day_info2['humidity'] else 0
                    avg_wind2 = sum(day_info2['wind_speed']) / \
                        len(day_info2['wind_speed']) if day_info2['wind_speed'] else 0

                    day_name2 = day_date2.strftime('%A')
                    date_str2 = day_date2.strftime('%Y-%m-%d')
                    midday_timestamp2 = int(datetime.combine(
                        day_date2, datetime.min.time()).replace(hour=12).timestamp())
                    icon2 = self.get_weather_icon(
                        condition2, midday_timestamp2, sunrise, sunset, True)

            # Build output lines for both columns
            col_width = int((self.MAX_COLUMNS - self.BORDERS) / 2)

            # Top border
            if has_second_col:
                border = f"├{'─' * col_width}┬{'─' * (col_width - 1)}┤" if i == 0 else f"┌{'─' * col_width}┬{'─' * (col_width - 1)}┐"
            else:
                border = f"├{'─' * col_width}┤" if i == 0 else f"┌{'─' * col_width}┐"
            output.append(border)

            # Date header row
            line1 = f"📆 {day_name1}, {date_str1}"
            line2 = f"📆 {day_name2}, {date_str2}" if has_second_col else ""
            output.append(self.get_formatted_line(line1, line2, has_second_col, col_width - 1))

            # Separator after header
            if has_second_col:
                separator = f"├{'─' * (col_width)}┼{'─' * (col_width - 1)}┤"
            else:
                separator = f"├{'─' * (col_width - 1)}┤"
            output.append(separator)

            # Min/Max temperature row
            line1 = f" 🌡️ Min/Max: {min_temp1:.1f}{temp_unit} / {max_temp1:.1f}{temp_unit}"
            line2 = f" 🌡️ Min/Max: {min_temp2:.1f}{temp_unit} / {max_temp2:.1f}{temp_unit}" if has_second_col else ""
            output.append(self.get_formatted_line(line1, line2, has_second_col, col_width))

            # Average temperature row
            line1 = f" 📊 Average: {avg_temp1:.1f}{temp_unit}"
            line2 = f" 📊 Average: {avg_temp2:.1f}{temp_unit}" if has_second_col else ""
            output.append(self.get_formatted_line(line1, line2, has_second_col, col_width - 1))

            # Conditions row
            line1 = f" {icon1}Conditions: {condition1.title()}"
            line2 = f" {icon2}Conditions: {condition2.title()}" if has_second_col else ""
            output.append(self.get_formatted_line(line1, line2, has_second_col, col_width))

            # Humidity row
            line1 = f" 💧 Humidity: {avg_humidity1:.0f}%"
            line2 = f" 💧 Humidity: {avg_humidity2:.0f}%" if has_second_col else ""
            output.append(self.get_formatted_line(line1, line2, has_second_col, col_width - 1))

            # Wind row
            line1 = f" 💨 Wind: {avg_wind1:.1f} {speed_unit}"
            line2 = f" 💨 Wind: {avg_wind2:.1f} {speed_unit}" if has_second_col else ""
            output.append(self.get_formatted_line(line1, line2, has_second_col, col_width - 1))

            # Rain row (if applicable)
            if day_info1['rain'] > 0 or (has_second_col and day_info2['rain'] > 0):
                line1 = f" 🌧️ Rain: {day_info1['rain']:.1f} mm" if day_info1['rain'] > 0 else ""
                line2 = f" 🌧️ Rain: {day_info2['rain']:.1f} mm" if day_info2['rain'] > 0 else ""
                output.append(self.get_formatted_line(line1, line2, has_second_col, col_width))

            # Snow row (if applicable)
            if day_info1['snow'] > 0 or (has_second_col and day_info2['snow'] > 0):
                line1 = f" ❄️ Snow: {day_info1['snow']:.1f} mm" if day_info1['snow'] > 0 else ""
                line2 = f" ❄️ Snow: {day_info2['snow']:.1f} mm" if day_info2['snow'] > 0 else ""
                output.append(self.get_formatted_line(line1, line2, has_second_col, col_width))

            # Bottom border
            if has_second_col:
                border = f"└{'─' * (col_width)}┴{'─' * (col_width - 1)}┘"
            else:
                border = f"└{'─' * (col_width - 1)}┘"
            output.append(border)

        return output

    def organize_forecast_per_date(self, forecast_list: list) -> dict:
        # Organize forecast by day
        daily_data = {}
        for item in forecast_list:
            dt = item.get('dt')
            if not dt:
                continue

            dt_obj = datetime.fromtimestamp(dt)
            date_key = dt_obj.date()

            if date_key not in daily_data:
                daily_data[date_key] = {
                    'temps': [],
                    'conditions': [],
                    'humidity': [],
                    'wind_speed': [],
                    'rain': 0,
                    'snow': 0
                }

            main = item.get('main', {})
            daily_data[date_key]['temps'].append(main.get('temp'))

            weather = item.get('weather', [{}])[0]
            daily_data[date_key]['conditions'].append(weather.get('description', ''))

            daily_data[date_key]['humidity'].append(main.get('humidity', 0))

            wind = item.get('wind', {})
            daily_data[date_key]['wind_speed'].append(wind.get('speed', 0))

            # Accumulate rain and snow
            if 'rain' in item and '3h' in item['rain']:
                daily_data[date_key]['rain'] += item['rain']['3h']
            if 'snow' in item and '3h' in item['snow']:
                daily_data[date_key]['snow'] += item['snow']['3h']

        return daily_data

    def format_forecast(self, data: dict, units: str = "metric") -> str:
        """Format forecast data showing current weather and daily min/max.

        Args:
            data: Forecast data dictionary
            units: Units of measurement used

        Returns:
            Formatted weather forecast string
        """
        output_lines = []

        # Temperature units
        temp_unit = "°C" if units == "metric" else "°F" if units == "imperial" else "K"
        speed_unit = "m/s" if units == "metric" else "mph" if units == "imperial" else "m/s"

        # Location info
        city = data.get('city', {})
        sunrise = city.get('sunrise')
        sunset = city.get('sunset')

        # Get forecast list
        forecast_list = data.get('list', [])
        if not forecast_list:
            output_lines.append("No forecast data available")
            return '\n'.join(output_lines)

        # Get Current Weather summary
        output_lines.extend(self.create_current_weather_summary(
            forecast_list[0], city, sunrise, sunset, temp_unit, speed_unit))

        # Get Daily Forecast summary
        output_lines.extend(self.create_daily_forecast_summary(
            forecast_list, sunrise, sunset, temp_unit, speed_unit))

        return '\n'.join(output_lines)

    def format_waybar(self, data: dict, units: str = "metric") -> str:
        """Format weather data as Waybar JSON output.

        Args:
            data: Forecast data dictionary
            units: Units of measurement used

        Returns:
            JSON string for Waybar
        """
        # Temperature units
        temp_unit = "°C" if units == "metric" else "°F" if units == "imperial" else "K"

        # Location info
        city = data.get('city', {})
        sunrise = city.get('sunrise')
        sunset = city.get('sunset')

        # Get forecast list
        forecast_list = data.get('list', [])
        if not forecast_list:
            return json.dumps({"text": "N/A", "tooltip": "No weather data available"})

        # Current weather (first entry)
        current = forecast_list[0]
        current_main = current.get('main', {})
        current_weather = current.get('weather', [{}])[0]
        current_condition = current_weather.get('description', 'N/A')
        current_dt = current.get('dt')
        current_temp = floor(current_main.get('temp')) if isinstance(
            current_main.get('temp'), numbers.Number) else 'N/A'

        # Get weather icon for current conditions
        weather_icon = self.get_weather_icon(
            current_condition, current_dt, sunrise, sunset, False).strip()

        # Create text field (shown in bar)
        text = f"{weather_icon} {current_temp}{temp_unit}"

        # Create tooltip with full forecast
        tooltip = self.format_forecast(data, units)

        # Determine class based on conditions
        condition_lower = current_condition.lower()
        if 'clear' in condition_lower:
            css_class = "clear"
        elif 'cloud' in condition_lower:
            css_class = "cloudy"
        elif 'rain' in condition_lower:
            css_class = "rainy"
        elif 'thunder' in condition_lower or 'storm' in condition_lower:
            css_class = "stormy"
        elif 'snow' in condition_lower:
            css_class = "snowy"
        elif 'mist' in condition_lower or 'fog' in condition_lower:
            css_class = "foggy"
        else:
            css_class = "default"

        # Create Waybar JSON output
        waybar_output = {
            "text": text,
            "tooltip": tooltip,
            "class": css_class
        }

        return json.dumps(waybar_output, ensure_ascii=True)


def main():
    """Main function to run the weather script."""
    parser = argparse.ArgumentParser(
        description='Fetch weather forecast from OpenWeather API 2.5',
        formatter_class=argparse.RawDescriptionHelpFormatter,
        epilog="""
TODO: fix this
Examples:
  # Forecast by coordinates
  %(prog)s --lat 40.7128 --lon -74.0060

  # Forecast by city name
  %(prog)s --city "New York,US"

  # Forecast with imperial units
  %(prog)s --city "London,UK" --units imperial

  # Output for Waybar custom module
  %(prog)s --city "London,UK" --waybar

Environment Variables:
  OPENWEATHER_API_KEY: Your OpenWeather API key (required if --api-key not provided)
        """
    )

    parser.add_argument('--lat', type=float,
                        help='Latitude coordinate')
    parser.add_argument('--lon', type=float,
                        help='Longitude coordinate')
    parser.add_argument('--city', type=str,
                        help='City name (e.g., "London" or "London,UK")')
    parser.add_argument('--api-key', type=str,
                        help='OpenWeather API key (or set OPENWEATHER_API_KEY env var)')
    parser.add_argument('--units', type=str, default='metric',
                        choices=['standard', 'metric', 'imperial'],
                        help='Units of measurement (default: metric)')
    parser.add_argument('--json', action='store_true',
                        help='Output raw API JSON instead of formatted text')
    parser.add_argument('--waybar', action='store_true',
                        help='Output in Waybar JSON format (text, tooltip, class)')

    args = parser.parse_args()

    # Validate location arguments
    has_coords = args.lat is not None and args.lon is not None
    has_city = args.city is not None

    if not has_coords and not has_city:
        print("Error: Must provide either --city or both --lat and --lon", file=sys.stderr)
        sys.exit(1)

    if has_coords and has_city:
        print("Error: Cannot use both --city and coordinates", file=sys.stderr)
        sys.exit(1)

    # Get API key from argument or environment variable
    api_key = args.api_key or os.environ.get('OPENWEATHER_API_KEY')

    if not api_key:
        print("Error: API key not provided.", file=sys.stderr)
        print("Please provide it via --api-key argument or OPENWEATHER_API_KEY environment variable.",
              file=sys.stderr)
        sys.exit(1)

    # Fetch and display weather forecast
    try:
        client = WeatherAPI(api_key)

        if has_city:
            data = client.get_forecast(city=args.city, units=args.units)
        else:
            data = client.get_forecast(lat=args.lat, lon=args.lon, units=args.units)

        if args.json:
            print(json.dumps(data, indent=2))
        elif args.waybar:
            print(client.format_waybar(data, args.units))
        else:
            print(client.format_forecast(data, args.units))

    except Exception as e:
        # For waybar, output error as JSON
        if args.waybar:
            error_output = {
                "text": "⚠️ N/A",
                "tooltip": f"Error: {str(e)}",
                "class": "error"
            }
            print(json.dumps(error_output, ensure_ascii=False))
        else:
            print(f"Error fetching weather data: {e}", file=sys.stderr)
        sys.exit(1)


if __name__ == '__main__':
    main()
