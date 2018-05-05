//
//  CurrentForecastViewController.swift
//  DLWeatherApp
//
//  Created by Donovan Cotter on 5/1/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentForecastViewController: UIViewController, CLLocationManagerDelegate {
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    private var locationManager = CLLocationManager()
    private var currentForecastLocation: Location? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        LocationManager().setup(locationManager: locationManager)
        locationManager.delegate = self
    }

    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let updatedLocation = locations.last else {
            return
        }
        
        let location = Location(coordinate: updatedLocation)
        getCurrentWeather(for: location)
    }
    
    private func getCurrentWeather(for location: Location) {
        location.coordiante.address(handler: { (address) in
            if let cityAndState = address {
                self.currentForecastLocation = location
                self.currentForecastLocation?.update(with: cityAndState)
                self.display(location: self.currentForecastLocation!)
                self.currentWeatherOperaton(for: self.currentForecastLocation!)
            }
        })
    }
    
    private func currentWeatherOperaton(for location: Location) {
        NetworkOperation().getCurrentForecast(for: location) { (currentWeather) in
            if let currentTemp = currentWeather?.currentTemperature {
                DispatchQueue.main.async {
                    self.currentTempLabel.text = "\(currentTemp)°"
                }
            }
        }
    }
    
    private func display(location: Location) {
        if let city = location.city, let state = location.state {
            self.locationLabel.text = "\(city), \(state)"
        }
    }
    
}
