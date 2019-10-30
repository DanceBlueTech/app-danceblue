//
//  GeoFencing.swift
//  app-danceblue
//
//  Created by David Mercado on 10/6/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import CoreLocation

class Geotification: NSObject, Codable {
    enum EventType: String {
        case onEntry = "On Entry"
        case onExit = "On Exit"
    }
    enum CodingKeys: String, CodingKey {
        case latitude, longitude, radius, identifier, note, eventType
    }
    
    var coordinate: CLLocationCoordinate2D
    var radius: CLLocationDistance
    var identifier: String = ""
    var note: String = ""
    var eventType: EventType
    
    init(coordinate: CLLocationCoordinate2D, radius: CLLocationDistance, eventType: EventType) {
        self.coordinate = coordinate
        self.radius = radius
        self.eventType = eventType
    }
    // MARK: Codable
    required init(from decoder: Decoder) throws {
      let values = try decoder.container(keyedBy: CodingKeys.self)
      let latitude = try values.decode(Double.self, forKey: .latitude)
      let longitude = try values.decode(Double.self, forKey: .longitude)
      coordinate = CLLocationCoordinate2DMake(latitude, longitude)
      radius = try values.decode(Double.self, forKey: .radius)
      identifier = try values.decode(String.self, forKey: .identifier)
      note = try values.decode(String.self, forKey: .note)
      let event = try values.decode(String.self, forKey: .eventType)
      eventType = EventType(rawValue: event) ?? .onEntry
    }

    func encode(to encoder: Encoder) throws {
      var container = encoder.container(keyedBy: CodingKeys.self)
      try container.encode(coordinate.latitude, forKey: .latitude)
      try container.encode(coordinate.longitude, forKey: .longitude)
      try container.encode(radius, forKey: .radius)
      try container.encode(identifier, forKey: .identifier)
      try container.encode(note, forKey: .note)
      try container.encode(eventType.rawValue, forKey: .eventType)
    }
}

//TODO: save pulled geolocations from firebase to local storage in users device

 extension Geotification {
   public class func allGeotifications() -> [Geotification] {
     guard let savedData = UserDefaults.standard.data(forKey: "Test") else { return [] }
     let decoder = JSONDecoder()
     if let savedGeotifications = try? decoder.decode(Array.self, from: savedData) as [Geotification] {
       return savedGeotifications
     }
     return []
   }
 }
 
