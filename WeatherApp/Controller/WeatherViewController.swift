//
//  ViewController.swift
//  WeatherApp
//
//  Created by Kris on 14/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import UIKit

class WeatherViewController: UIViewController {
    
    @IBOutlet weak var conditionImageView: UIImageView!
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var maxTemperatureLabel: UILabel!
    @IBOutlet weak var minTemperatureLabel: UILabel!
    @IBOutlet weak var windSpeedLabel: UILabel!
    @IBOutlet weak var windDirectionLabel: UILabel!
    @IBOutlet weak var pressureLabel: UILabel!
    @IBOutlet weak var humidityLabel: UILabel!
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var weatherManager = WeatherManager()
    private var currentIndex = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousButton.setTitleColor(.gray, for: .disabled)
        nextButton.setTitleColor(.gray, for: .disabled)
        
        weatherManager.delegate = self
        weatherManager.performRequest(day: currentIndex)
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        currentIndex -= 1
        setupButtons()
        weatherManager.performRequest(day: currentIndex)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        currentIndex += 1
        setupButtons()
        weatherManager.performRequest(day: currentIndex)
    }
    
    private func setupButtons() {
        
        previousButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = (currentIndex) < 7
        
    }
}

//MARK: - WeatherManagerDelegate

extension WeatherViewController: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.sync {
            self.dateLabel.text = weather.dateString
            self.conditionImageView.image = UIImage(systemName: weather.conditionName)
            self.minTemperatureLabel.text = weather.minTemperatureString
            self.maxTemperatureLabel.text = weather.maxTemperatureString
            self.windSpeedLabel.text = weather.windSpeedString
            self.windDirectionLabel.text = weather.windDirectionString
            self.pressureLabel.text = weather.pressureString
            self.humidityLabel.text = weather.humidityString
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
