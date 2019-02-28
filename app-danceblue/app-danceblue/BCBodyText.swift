//
//  BCBodyText.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/2/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class BCBodyText: Mappable {
    
    var bodyText: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        bodyText <- map["text"]
    }
    
}
