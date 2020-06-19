//
//  WeatherModelCity.swift
//  WeatherApp
//
//  Created by Kris on 18/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//


import Foundation

struct WeatherModelCity {
    
    let conditionId: Int
    let temperature: Double
    let lon: Double
    let lat: Double
    
    var conditionName: String {
        switch conditionId {
        case 200...232:
            return "cloud.bolt"
        case 300...321:
            return "cloud.drizzle"
        case 500...531:
            return "cloud.rain"
        case 600...622:
            return "cloud.snow"
        case 701...781:
            return "cloud.fog"
        case 800:
            return "sun.max"
        case 801...804:
            return "cloud.bolt"
        default:
            return "cloud"
        }
    }
    
    var temperatureString: String {
        return String(format: "%.0f", temperature)
    }
}
