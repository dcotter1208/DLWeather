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

    fileprivate let tempFahrenheitKey = "temp_f"
    fileprivate let currentObservation = "current_observation"

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
    
    func getTenDayForecast(for location: Location, completion: @escaping CurrentWeatherResponse) {
        
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
        }
        
    }

    private func request(_ urlString: String, completion: @escaping WeatherResponse) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        Alamofire.request(url).responseJSON { response in
            if let json = response.result.value {
                print("\(json)")
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
        
        guard let currentWeather = weatherJson[currentObservation] as? WeatherJson else {
            return weather
        }
        
        if let currentTemp = currentWeather[tempFahrenheitKey] as? Double {
            weather.currentTemperature = "\(currentTemp)"
        }
        
        return weather
    }
    
    fileprivate func parseTenDayWeather(weatherJson: WeatherJson) -> [Weather] {
        return [Weather()]
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
