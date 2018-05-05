//
//  TenDayForecastTableViewController.swift
//  DLWeather
//
//  Created by Donovan Cotter on 5/5/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import UIKit
import CoreLocation

class TenDayForecastTableViewController: UITableViewController, CLLocationManagerDelegate {
    @IBOutlet var forecastTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        return cell
    }
    
    @IBAction func doneSelected(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
