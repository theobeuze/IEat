//
//  Shop.swift
//  IEat
//
//  Created by Poseidon on 31/01/2018.
//  Copyright © 2018 Theo Beuze. All rights reserved.
//

import Foundation
import MapKit

class Shop : NSObject, MKAnnotation {
    var title: String?
    var geometry: Geometry?
    var icon: String?
    
    var coordinate: CLLocationCoordinate2D {
        if let latitude = geometry?.location?.lat,
            let longitude = geometry?.location?.lng {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        } else {
            return CLLocationCoordinate2D(latitude: 0, longitude: 0)
        }
    }
}

class Geometry {
    var location: Location?
    
    init?(json: [String: Any]) {
        guard let location = json["location"] as! [String: Any]?
            else {
            return nil
        }
        if let realLocation = Location(json: location) {
            self.location = realLocation
        }
    }
}

class Location {
    var lat: Double?
    var lng: Double?
    
    init?(json: [String: Any]) {
        guard let lat = json["lat"] as? Double,
            let lng = json["lng"] as? Double
            else {
                return nil
        }
        self.lat = lat
        self.lng = lng
    }
}
