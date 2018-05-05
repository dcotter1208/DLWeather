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

typealias WeatherResponse = ([String : String]?) -> Void

struct NetworkOperation {
    
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
                guard let weather = json as? [String : Any] else {
                    completion(nil)
                    return
                }
                print("\(weather)")
            }
        }
    }
    
}
