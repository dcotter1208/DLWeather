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

typealias WeatherResponse = (Weather?) -> Void
private typealias WeatherJson = [String: Any]

struct NetworkOperation {

    fileprivate let tempFahrenheitKey = "temp_f"
    fileprivate let currentObservation = "current_observation"
    
    func getWeather(forecast: ForecastRequest, for location: Location, completion: @escaping WeatherResponse) {
        
        guard let city = location.city, let state = location.state else {
            completion(nil)
            return
        }
        
        let baseURL = "http://api.wunderground.com/api/"
        let key = "API_KEY"
        let locationString = "\(state)/\(city)"
        let constructedURL = "\(baseURL)\(key)/\(forecast.rawValue)/q/\(locationString).json"
        
        guard let url = URL(string: constructedURL) else {
            completion(nil)
            return
        }
        
        Alamofire.request(url.absoluteString).responseJSON { response in
            if let json = response.result.value {
                guard let weatherJson = json as? WeatherJson else {
                    completion(nil)
                    return
                }
                
                let weather = self.parse(weatherJson: weatherJson)
                completion(weather)
            }
        }
    }
    
    private func parse(weatherJson: WeatherJson) -> Weather {
        var weather = Weather()
        
        guard let currentWeather = weatherJson[currentObservation] as? WeatherJson else {
            return weather
        }

        if let currentTemp = currentWeather[tempFahrenheitKey] as? Double {
            weather.currentTemperature = "\(currentTemp)"
        }

        return weather
    }
}









