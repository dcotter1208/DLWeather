//
//  NetworkOperation.swift
//  DLWeather
//
//  Created by Donovan Cotter on 5/4/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import Foundation
import Alamofire

typealias WeatherResponse = ([String : String]?) -> Void

struct NetworkOperation {
    
    func getCurrentWeather(completion: @escaping WeatherResponse) {
        let key = ""
        guard let url = URL(string: "http://api.wunderground.com/api/\(key)/conditions/q/MI/Detroit.json") else {
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
