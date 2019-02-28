//
//  Sponsor.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 10/29/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class Sponsor: Mappable {
    
    public var id: String?
    public var image: String?
    public var link: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        image <- map["image"]
        id <- map["id"]
        link <- map["link"]
    }
    
}
