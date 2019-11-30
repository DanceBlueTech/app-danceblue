//
//  LocationConverter.swift
//  app-danceblue
//
//  Created by David Mercado on 11/28/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import MapKit

#warning("FIX ME")
struct LocationConverter {
    
    struct AddressToCoordinates {
        
        //return lat and long coords as well as a bool of conversion successfull
        static func getCoords(Address: String) {
            let geoCoder = CLGeocoder()
            geoCoder.geocodeAddressString(Address) { (placemarks, error) in
                guard
                    let placemarks = placemarks,
                    let location = placemarks.first?.location
                    else {
                        // handle no location found
                        print("not a location! Returning")
                        return
                }
                print("placemarkers \(placemarks)")
                print("location \(location)")
                // Use your location
            }
        }
    }
}

