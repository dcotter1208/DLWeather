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
    private var tenDayForecast = [Weather]()
    
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
        getWeather(for: location)
    }

    private func getWeather(for location: Location) {
        location.coordiante.address(handler: { (address) in
            if let cityAndState = address {
                self.currentForecastLocation = location
                self.currentForecastLocation?.update(with: cityAndState)
                self.display(location: self.currentForecastLocation!)
                self.currentForecastOperaton(for: self.currentForecastLocation!)
                self.tenDayForecastOperation(for: self.currentForecastLocation!)
            }
        })
    }
    
    private func currentForecastOperaton(for location: Location) {
        NetworkOperation().getCurrentForecast(for: location) { (currentWeather) in
            if let currentTemp = currentWeather?.currentTemperature {
                DispatchQueue.main.async {
                    self.currentTempLabel.text = "\(currentTemp)°"
                }
            }
        }
    }
    
    private func tenDayForecastOperation(for location: Location) {
        NetworkOperation().getTenDayForecast(for: location) { (tenDayForecast) in
            guard let forecast = tenDayForecast else { return }
            self.tenDayForecast = forecast
        }
    }
    
    private func display(location: Location) {
        if let city = location.city, let state = location.state {
            self.locationLabel.text = "\(city), \(state)"
        }
    }
    
}
