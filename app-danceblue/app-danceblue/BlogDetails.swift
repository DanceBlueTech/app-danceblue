//
//  BlogDetails.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 8/2/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class BlogDetails: Mappable {
    
    var author: String?
    var title: String?
    var timestamp: Date?
    var image: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        author <- map["author"]
        title <- map["title"]
        image <- map["image"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let dateString = map["timestamp"].currentValue as? String, let date = dateFormatter.date(from: dateString) {
            timestamp = date
        }
    }
}
