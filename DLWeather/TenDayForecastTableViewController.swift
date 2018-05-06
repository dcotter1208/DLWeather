//
//  TenDayForecastTableViewController.swift
//  DLWeather
//
//  Created by Donovan Cotter on 5/5/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import UIKit
import CoreLocation
import Alamofire
import AlamofireImage

class TenDayForecastTableViewController: UITableViewController, CLLocationManagerDelegate {
    @IBOutlet var forecastTableView: UITableView!
    var tenDayForecast = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tenDayForecast.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCellIdentifier", for: indexPath)
        let forecast = tenDayForecast[indexPath.row]
        if let date = forecast.date, let highTemp = forecast.highTemperature, let lowTemp = forecast.lowTemperature, let urlString = forecast.iconURL {
            let url = URL(string: urlString)
            let placeholderImage = #imageLiteral(resourceName: "placeholder")
            cell.imageView?.af_setImage(withURL: url!, placeholderImage: placeholderImage)
            cell.textLabel?.text = date
            cell.detailTextLabel?.text = "High: \(highTemp) Low: \(lowTemp)"
            cell.textLabel?.textColor = .white
            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 16.0)
        }

        return cell
    }
    
    @IBAction func doneSelected(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
