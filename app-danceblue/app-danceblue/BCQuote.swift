//
//  BCQuote.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/2/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class BCQuote: Mappable {
    
    var quote: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        quote <- map["quote"]
    }
    
}
