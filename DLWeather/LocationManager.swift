//
//  LocationManager.swift
//  DLWeatherApp
//
//  Created by Donovan Cotter on 5/1/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import Foundation
import CoreLocation

struct LocationManager {
    func setup(locationManager: CLLocationManager) {
        locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 750
            locationManager.startUpdatingLocation()
        }
    }
}
