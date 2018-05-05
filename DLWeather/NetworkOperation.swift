//
//  NetworkOperation.swift
//  DLWeather
//
//  Created by Donovan Cotter on 5/4/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import Foundation
import Alamofire

enum ForecastRequest: String {
    case current = "conditions"
    case tenDay = "forecast10day"
}

private typealias WeatherJson = [String: Any]
private typealias WeatherResponse = (WeatherJson?) -> Void
typealias CurrentWeatherResponse = (Weather?) -> Void
typealias TenDayWeatherResponse = ([Weather]?) -> Void

struct NetworkOperation {
    
    //Weather Json Keys
    fileprivate let tempFahrenheitKey = "temp_f"
    fileprivate let currentObservationKey = "current_observation"
    fileprivate let forecastKey = "forecast"
    fileprivate let simpleForecastKey = "simpleforecast"
    fileprivate let dateKey = "date"
    fileprivate let highTempKey = "high"
    fileprivate let lowTempKey = "low"
    fileprivate let iconUrlKey = "icon_url"
    fileprivate let monthNameKey = "monthname_short"
    fileprivate let dayKey = "day"
    fileprivate let weekdayKey = "weekday_short"
    fileprivate let highLowTempFahrenheitKey = "fahrenheit"
    
    func getCurrentForecast(for location: Location, completion: @escaping CurrentWeatherResponse) {
        
        guard let url = constructURL(with: location, forecast: .current) else {
            completion(nil)
            return
        }
        
        request(url) { (weatherResponse) in
            
            guard let weather = weatherResponse else {
                completion(nil)
                return
            }
            
            let currentWeather = self.parseCurrent(weatherJson: weather)
            completion(currentWeather)
        }
    }
    
    func getTenDayForecast(for location: Location, completion: @escaping TenDayWeatherResponse) {
        
        guard let url = constructURL(with: location, forecast: .tenDay) else {
            completion(nil)
            return
        }
        
        request(url) { (weatherResponse) in
            
            guard let weather = weatherResponse else {
                completion(nil)
                return
            }
            
            let tenDayForecast = self.parseTenDayWeather(weatherJson: weather)
            completion(tenDayForecast)
        }
    }

    private func request(_ urlString: String, completion: @escaping WeatherResponse) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                guard let weatherJson = json as? WeatherJson else {
                    completion(nil)
                    return
                }
                completion(weatherJson)
            }
        }
    }
    
    private func parseCurrent(weatherJson: WeatherJson) -> Weather {
        var weather = Weather()
        
        guard let currentWeather = weatherJson[currentObservationKey] as? WeatherJson else {
            return weather
        }
        
        if let currentTemp = currentWeather[tempFahrenheitKey] as? Double {
            weather.currentTemperature = "\(currentTemp)"
        }
        
        return weather
    }
    
    fileprivate func parseTenDayWeather(weatherJson: WeatherJson) -> [Weather] {
        var tenDayForecast = [Weather]()

        guard let forecastDict = weatherJson[forecastKey] as? WeatherJson,
        let forecastDayDict = forecastDict[simpleForecastKey] as? WeatherJson,
        let forecastDayArray = forecastDayDict["forecastday"] as? [WeatherJson] else {
                return tenDayForecast
        }
        
        for forecastDay in forecastDayArray {
            if let dateDict = forecastDay[dateKey] as? WeatherJson,
                let highTempDict = forecastDay[highTempKey] as? WeatherJson,
                let lowTempDict =  forecastDay[lowTempKey] as? WeatherJson,
                let iconUrl = forecastDay[iconUrlKey] as? String {

                let date = constructDateString(from: dateDict)
                let highTemp = constructTempString(from: highTempDict)
                let lowTemp = constructTempString(from: lowTempDict)

                let tenDayForecastDay = Weather(currentTemperature: nil, date: date, lowTemperature: lowTemp, highTemperature: highTemp, iconURL: iconUrl)
                tenDayForecast.append(tenDayForecastDay)
            }
        }
        
        return tenDayForecast
    }
    
    private func constructDateString(from date: WeatherJson) -> String? {
        if let weekday = date[weekdayKey] as? String,
            let day = date[dayKey] as? Int,
            let month = date[monthNameKey] as? String {
            return "\(weekday), \(month) \(day)"
        }
        return nil
    }
    
    private func constructTempString(from temp: WeatherJson) -> String? {
        if let temperature = temp[highLowTempFahrenheitKey] as? String {
            return temperature
        }
        return nil
    }
    
    private func constructURL(with location: Location, forecast: ForecastRequest) -> String? {
        guard let city = location.city, let state = location.state else {
            return nil
        }
        
        let baseURL = "http://api.wunderground.com/api/"
        let key = "adbcb99eace93b15"
        let locationString = "\(state)/\(city)"
        let constructedURL = "\(baseURL)\(key)/\(forecast.rawValue)/q/\(locationString).json"
        
        return constructedURL
    }
}
