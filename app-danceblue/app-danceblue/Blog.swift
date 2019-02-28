//
//  Blog.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 7/31/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class Blog: Mappable {
    
    public var id: String?
    public var details: BlogDetails?
    public var chunks: [BCData]? 
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        chunks <- map["chunks"]
        id <- map["id"]
        details <- map["details"]
    }
    
}
