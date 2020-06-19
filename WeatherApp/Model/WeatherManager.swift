//
//  WeatherManager.swift
//  WeatherApp
//
//  Created by Kris on 14/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import Foundation

protocol WeatherManagerDelegate {
    func didUpdateWeather(_ weatherManager: WeatherManager, weather: WeatherModel)
    func didUpdateWeather(_ weatherManager: WeatherManager, weatherCity: WeatherModelCity)
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    static let baseURL = "https://api.openweathermap.org/data/2.5/weather?appid=1c197254ed8743944deb1b69560c18f9&units=metric"
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely,hourly,current&appid=1c197254ed8743944deb1b69560c18f9&units=metric"
    
    var delegate: WeatherManagerDelegate?
    
    func fetchWeather(cityName: String) {
        let urlString = "\(WeatherManager.baseURL)&q=\(cityName)"
        performRequest(with: urlString)
    }
    
    //MARK: - WeatherView
    
    func performRequest(lat: Double, lon: Double, day: Int) {
        
        let urlString = "\(weatherURL)&lat=\(lat)&lon=\(lon)"
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData, day) {
                        self.delegate?.didUpdateWeather(self, weather: weather)
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data, _ day: Int) -> WeatherModel? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherData.self, from: weatherData)
            let id = decodedData.daily[day].weather[0].id
            let minTemp = decodedData.daily[day].temp.min
            let maxTemp = decodedData.daily[day].temp.max
            let date = decodedData.daily[day].dt
            let pressure = decodedData.daily[day].pressure
            let windSpeed = decodedData.daily[day].wind_speed
            let windDirection = decodedData.daily[day].wind_deg
            let humidity = decodedData.daily[day].humidity
            
            let weather = WeatherModel(conditionId: id, minTemperature: minTemp, maxTemperature: maxTemp, date: date, pressure: pressure, windSpeed: windSpeed, windDirection: windDirection, humidity: humidity)
            
            return weather
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    //MARK: - MasterTableView
    
    func performRequest(with urlString: String) {
        
        if let url = URL(string: urlString) {
            let session = URLSession(configuration: .default)
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data {
                    if let weather = self.parseJSON(safeData) {
                        self.delegate?.didUpdateWeather(self, weatherCity: weather)
                        
                    }
                }
            }
            task.resume()
        }
    }
    
    func parseJSON(_ weatherData: Data) -> WeatherModelCity? {
        let decoder = JSONDecoder()
        do{
            let decodedData = try decoder.decode(WeatherDataCity.self, from: weatherData)
            let id = decodedData.weather[0].id
            let temp = decodedData.main.temp
            let lon = decodedData.coord.lon
            let lat = decodedData.coord.lat
            
            let weather = WeatherModelCity(conditionId: id, temperature: temp, lon: lon, lat: lat)
            
            return weather
            
        } catch {
            self.delegate?.didFailWithError(error: error)
            return nil
        }
    }
}
