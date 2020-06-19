//
//  WeatherDataCity.swift
//  WeatherApp
//
//  Created by Kris on 18/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import Foundation

struct WeatherDataCity: Codable {
    let main: Main
    let weather: [WeatherCity]
    let coord: Coord
}

struct Main: Codable {
    let temp: Double
}

struct WeatherCity: Codable {
    let id: Int
}

struct Coord: Codable {
    let lon: Double
    let lat: Double
}
