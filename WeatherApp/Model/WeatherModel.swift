//
//  WeatherModel.swift
//  WeatherApp
//
//  Created by Kris on 14/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import Foundation

struct WeatherModel {
    
    let conditionId: Int
    let minTemperature: Double
    let maxTemperature: Double
    let date: Int
    let pressure: Int
    let windSpeed: Double
    let windDirection: Int
    let humidity: Int
    
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
    
    var minTemperatureString: String {
        return String(format: "%.0f", minTemperature)
    }
    
    var maxTemperatureString: String {
        return String(format: "%.0f", maxTemperature)
    }
    
    var dateString: String {
        let dateTmp = NSDate(timeIntervalSince1970: TimeInterval(date))

        let dayTimePeriodFormatter = DateFormatter()
        dayTimePeriodFormatter.dateFormat = "dd/MM/YYYY"

        return dayTimePeriodFormatter.string(from: dateTmp as Date)
    }
   
    var pressureString: String {
        return String(pressure)
    }
    
    var windSpeedString: String {
        return String(format: "%.1f", windSpeed)
    }
        
    var windDirectionString: String {
        switch windDirection {
        case 0...11, 349...360:
            return "N"
        case 11...34:
            return "NNE"
        case 34...56:
            return "NE"
        case 56...79:
            return "ENE"
        case 79...101:
            return "E"
        case 101...124:
            return "ESE"
        case 124...146:
            return "SE"
        case 146...169:
            return "SSE"
        case 169...192:
            return "S"
        case 192...214:
            return "SSW"
        case 214...236:
            return "SW"
        case 236...259:
            return "WSW"
        case 259...281:
           return "W"
        case 281...304:
            return "WNW"
        case 304...326:
            return "NW"
        case 326...349:
            return "NNW"
        default:
            return "N"
        }
    }
    
    var humidityString: String {
        return String(humidity)
    }
}
