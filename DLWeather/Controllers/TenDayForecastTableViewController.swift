//
//  TenDayForecastTableViewController.swift
//  DLWeather
//
//  Created by Donovan Cotter on 5/5/18.
//  Copyright © 2018 DonovanCotter. All rights reserved.
//

import UIKit
import Alamofire
import AlamofireImage

class TenDayForecastTableViewController: UITableViewController {
    @IBOutlet var forecastTableView: UITableView!
    var tenDayForecast = [Weather]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tenDayForecast.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "WeatherCellIdentifier", for: indexPath) as! WeatherCell
        let forecast = tenDayForecast[indexPath.row]
        
        if let date = forecast.date, let highTemp = forecast.highTemperature, let lowTemp = forecast.lowTemperature, let urlString = forecast.iconURL {
            cell.dateLabel.text = date
            cell.tempLabel.text = "High: \(highTemp) Low: \(lowTemp)"
            let url = URL(string: urlString)
            cell.iconImageView?.af_setImage(withURL: url!, placeholderImage: #imageLiteral(resourceName: "placeholder"))
        }

        return cell
    }
    
    @IBAction func doneSelected(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
}
