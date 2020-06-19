//
//  CityModel.swift
//  WeatherApp
//
//  Created by Kris on 17/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import Foundation
import Combine

class CityModel {
    
    var didChange = PassthroughSubject<CityModel, Never>()
    var weatherManager = WeatherManager()
    
    
    let name: String
    
    var weather: WeatherModelCity? {
        didSet {
            didChange.send(self)
        }
    }
    
    var weatherDetail: WeatherModel? {
        didSet {
            didChange.send(self)
        }
    }
    
    init(name: String) {
        self.name = name
        weatherManager.delegate = self
        weatherManager.fetchWeather(cityName: name)
        //self.getWeather()
    }
    
//    private func getWeather() {
//        guard let url = URL(string: WeatherManager.baseURL + "&q=\(name)") else {
//            return
//        }
//        
//        URLSession.shared.dataTask(with: url) { (data, response, error) in
//            guard let data = data else {
//                return
//            }
//            
//            do {
//                let decoder = JSONDecoder()
//                decoder.dateDecodingStrategy = .secondsSince1970
//                
//                let weatherObject = try decoder.decode(WeatherData.self, from: data)
//                
//                DispatchQueue.main.async {
//                    self.weather = weatherObject
//                }
//            } catch {
//                print(error.localizedDescription)
//            }
//        }.resume()
//    }
}

extension CityModel: WeatherManagerDelegate {
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel) {
        DispatchQueue.main.sync {
            self.weatherDetail = weather
            
        }
    }
    
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherCity: WeatherModelCity) {
        DispatchQueue.main.sync {
            self.weather = weatherCity
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }
}
