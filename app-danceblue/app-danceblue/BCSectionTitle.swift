//
//  BCSectionTitle.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/4/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class BCSectionTitle: Mappable {
    
    var title: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        title <- map["title"]
    }
    
}
