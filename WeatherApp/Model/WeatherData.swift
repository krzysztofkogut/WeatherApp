//
//  WeatherData.swift
//  WeatherApp
//
//  Created by Kris on 14/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import Foundation

struct WeatherData: Codable {
    let daily: [Daily]
}

struct Daily: Codable {
    let dt: Int
    let temp: Temp
    let pressure: Int
    let wind_speed: Double
    let wind_deg: Int
    let weather: [Weather]
    let humidity: Int
}

struct Temp: Codable {
    let min: Double
    let max: Double
}

struct Weather: Codable {
    let id: Int
}
