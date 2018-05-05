//
//  CurrentForecastViewController.swift
//  DLWeatherApp
//
//  Created by Donovan Cotter on 5/1/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import UIKit
import CoreLocation

class CurrentForecastViewController: UIViewController {
    @IBOutlet weak var currentForecastImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    private let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.setup()
        
        let coordinates = CLLocation()
        let location = Location(coordinate: coordinates, city: "Detroit", state: "MI")
        NetworkOperation().getWeather(forecast: .current, for: location) { (response) in
            
        }
    
    }
}
