//
//  Location.swift
//  DLWeatherApp
//
//  Created by Donovan Cotter on 5/1/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import Foundation
import CoreLocation

private let cityKey = "city"
private let stateKey = "state"

struct Location {
    var coordiante: CLLocation
    var city: String?
    var state: String?
    
    init(coordinate: CLLocation, city: String? = nil, state: String? = nil) {
        self.coordiante = coordinate
        self.city = city
        self.state = state
    }
    
   mutating func update(with info: [String: String]) {
        if let city = info[cityKey], let state = info[stateKey] {
            self.city = city
            self.state = state
        }
    }
}

extension CLLocation {
    typealias reverseGeocodeHandler = ([String: String]?) -> Void
    
    func address(handler: @escaping reverseGeocodeHandler) {
        let geocoder = CLGeocoder()
        
        geocoder.reverseGeocodeLocation(self) { (placemarks, error) in
            guard error == nil else {
                handler(nil)
                return
            }
            
            guard let placemark = placemarks?.first, let city = placemark.locality, let state = placemark.administrativeArea else {
                handler(nil)
                return
            }

            let addressDict = [cityKey : city, stateKey: state]
            handler(addressDict)
        }
    }
}

