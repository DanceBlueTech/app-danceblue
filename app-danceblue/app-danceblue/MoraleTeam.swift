//
//  MoraleTeam.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 2/4/18.
//  Copyright © 2018 DanceBlue. All rights reserved.
//

import ObjectMapper

class MoraleTeam: Mappable {
    
    public var name: String?
    public var number: Int?
    public var points: Int?
    public var standing: Int?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        name <- map["name"]
        number <- map["number"]
        points <- map["points"]
        standing <- map["standing"]
    }
    
}

