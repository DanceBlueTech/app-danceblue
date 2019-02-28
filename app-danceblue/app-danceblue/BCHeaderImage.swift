//
//  BCHeaderImage.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/2/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class BCHeaderImage: Mappable {
    
    var description: String?
    var image: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        image <- map["image"]
        description <- map["description"]
    }
    
}
