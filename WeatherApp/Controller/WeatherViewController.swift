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
    @IBOutlet weak var cityLabel: UILabel!
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
    
    var city: CityModel? {
        didSet {
            refreshUI()
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previousButton.setTitleColor(.gray, for: .disabled)
        nextButton.setTitleColor(.gray, for: .disabled)
        
        weatherManager.delegate = self
        weatherManager.performRequest(lat: city?.weather?.lat ?? 48.85, lon: city?.weather?.lon ?? 2.35, day: currentIndex)
    }
    
    @IBAction func previousAction(_ sender: UIButton) {
        currentIndex -= 1
        setupButtons()
        weatherManager.performRequest(lat: (city?.weather?.lat)!, lon: (city?.weather?.lon)!, day: currentIndex)
    }
    
    @IBAction func nextAction(_ sender: UIButton) {
        currentIndex += 1
        setupButtons()
        weatherManager.performRequest(lat: (city?.weather?.lat)!, lon: (city?.weather?.lon)!, day: currentIndex)
    }
    
    private func setupButtons() {
        
        previousButton.isEnabled = currentIndex > 0
        nextButton.isEnabled = (currentIndex) < 7
    }
    
    private func refreshUI() {
        loadViewIfNeeded()
        cityLabel.text = city?.name
        weatherManager.performRequest(lat: (city?.weather?.lat)!, lon: (city?.weather?.lon)!, day: currentIndex)
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
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherCity: WeatherModelCity) {
        
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}

extension WeatherViewController: CitySelectionDelegate {
    func citySelected(_ newCity: CityModel) {
        city = newCity
    }
}
