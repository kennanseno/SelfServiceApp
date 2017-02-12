//
//  Location.swift
//  Self service App
//
//  Created by Kennan Lyle Seno on 11/02/2017.
//  Copyright © 2017 kennanseno. All rights reserved.
//

class Location {
    private var latitude: Double
    private var longitude: Double

    init() {
        self.latitude = 0.0
        self.longitude = 0.0
    }
    
    init(latitude: Double, longitude: Double) {
        self.latitude = latitude
        self.longitude = longitude
    }
    
    public func setLatitude(latitude: Double) {
        self.latitude = latitude
    }
    public func setLongitude(longitude: Double) {
        self.longitude = longitude
    }
    public func getLatitude() -> Double {
        return self.latitude
    }
    public func getLongitude() -> Double {
        return self.longitude
    }
}
