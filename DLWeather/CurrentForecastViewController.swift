//
//  CurrentForecastViewController.swift
//  DLWeatherApp
//
//  Created by Donovan Cotter on 5/1/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import UIKit

class CurrentForecastViewController: UIViewController {
    @IBOutlet weak var currentForecastImageView: UIImageView!
    @IBOutlet weak var locationLabel: UILabel!
    @IBOutlet weak var currentTempLabel: UILabel!
    
    private let locationManager = LocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationLabel.text = "HELLO"
        locationManager.setup()
    }
}
