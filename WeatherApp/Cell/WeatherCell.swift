//
//  WeatherCell.swift
//  WeatherApp
//
//  Created by Kris on 18/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import UIKit

class WeatherCell: UITableViewCell {

    @IBOutlet weak var temperatureLabel: UILabel!
    @IBOutlet weak var conditionImageView: UIImageView!
    
    func setWeather(weather: WeatherModelCity) {
        DispatchQueue.main.async {
            self.temperatureLabel.text = weather.temperatureString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
        }
    }
    
}
