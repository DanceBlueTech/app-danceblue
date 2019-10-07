//
//  GeoLocation.swift
//  app-danceblue
//
//  Created by David Mercado on 10/6/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import ObjectMapper

class GeoLocation: Mappable {
    
// These might need to be changed to Int?
    public var LocationName: String?
    public var Latitude: String?
    public var Longitude: String?
    public var Radius: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        LocationName <- map[kGeoLocationName]
        Latitude <- map[kGeoLocationLat]
        Longitude <- map[kGeoLocationLong]
        Radius <- map[kGeoLocationRadius]

        print("Location name: \(LocationName)")
        print("Lat: \(Latitude)")
        print("Long: \(Longitude)")
        print("Radius: \(Radius)")
    }
    
}
