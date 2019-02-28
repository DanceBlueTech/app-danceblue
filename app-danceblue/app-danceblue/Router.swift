//
//  Router.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 9/13/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import Foundation

struct Router {
    
    struct Maps {
        static func buildAddressURL(from address: String) -> URL {
            let baseURL = "http://maps.apple.com/?"
            return URL(string: "\(baseURL)address=\(address)")!
        }
    }
        
}
