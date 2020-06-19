//
//  CityStore.swift
//  WeatherApp
//
//  Created by Kris on 17/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//


import Combine

class CityStore {
    
    let didChange = PassthroughSubject<CityStore, Never>()
    
    var cities: [CityModel] = [CityModel(name: "Paris"), CityModel(name: "London"), CityModel(name: "Warsaw")] {
        didSet {
            didChange.send(self)
        }
    }
}
