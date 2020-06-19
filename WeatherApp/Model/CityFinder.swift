//
//  CityFinder.swift
//  WeatherApp
//
//  Created by Kris on 18/06/2020.
//  Copyright © 2020 Kris. All rights reserved.
//

import Combine
import MapKit

class CityFinder: NSObject, ObservableObject {
        
    var didChange = PassthroughSubject<CityFinder, Never>()
    
    var results: [String] = [] {
        didSet {
            didChange.send(self)
        }
    }
    
    private var searcher: MKLocalSearchCompleter
    
    override init() {
        results = []
        searcher = MKLocalSearchCompleter()
        super.init()
        searcher.resultTypes = .address
        searcher.delegate = self
    }
    
    func search(_ text: String) {
        searcher.queryFragment = text
    }
    
}

extension CityFinder: MKLocalSearchCompleterDelegate {
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        results = completer.results.map({ $0.title })
    }
    
}
