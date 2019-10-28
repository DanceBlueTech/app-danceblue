//
//  GeoFencing.swift
//  app-danceblue
//
//  Created by David Mercado on 10/6/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import CoreLocation

class Geotification: NSObject {
    enum EventType: String {
      case onEntry = "On Entry"
      case onExit = "On Exit"
    }
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String = ""
    //var note: String = ""
    var eventType: EventType
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, eventType: EventType) {
        self.coordinate = coordinate
        self.radius = radius
        self.eventType = eventType
    }
    
}

//TODO: save pulled geolocations from firebase to local storage in users device
/*
 extension Geotification {
   public class func allGeotifications() -> [Geotification] {
     guard let savedData = UserDefaults.standard.data(forKey: PreferencesKeys.savedItems) else { return [] }
     let decoder = JSONDecoder()
     if let savedGeotifications = try? decoder.decode(Array.self, from: savedData) as [Geotification] {
       return savedGeotifications
     }
     return []
   }
 }
 */
