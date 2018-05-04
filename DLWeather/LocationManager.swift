//
//  LocationManager.swift
//  DLWeatherApp
//
//  Created by Donovan Cotter on 5/1/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import Foundation
import CoreLocation

class LocationManager: NSObject, CLLocationManagerDelegate {
    private let locationManager = CLLocationManager()
    var location: Location? = nil
    
    func setup() {
        locationManager.requestWhenInUseAuthorization()
        
        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters
            locationManager.distanceFilter = 750
            locationManager.startUpdatingLocation()
        }
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let updatedLocation = locations.last else { return }
        location = Location(coordinate: updatedLocation)
    }
}
