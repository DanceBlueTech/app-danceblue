//
//  BCBodyImage.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/2/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class BCBodyImage: Mappable {
    
    var image: String?
    var description: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        image <- map["image"]
        description <- map ["description"]
    }

    
}
