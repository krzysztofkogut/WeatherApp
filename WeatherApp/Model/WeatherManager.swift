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
    func didFailWithError(error: Error)
}

struct WeatherManager {
    
    let weatherURL = "https://api.openweathermap.org/data/2.5/onecall?exclude=minutely,hourly,current&appid=1c197254ed8743944deb1b69560c18f9&units=metric&lat=48.85&lon=2.35"
    
    var delegate: WeatherManagerDelegate?
        
    func performRequest(day: Int) {
        
        if let url = URL(string: weatherURL) {
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
}
