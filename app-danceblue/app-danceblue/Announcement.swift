//
//  Announcement.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 7/23/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class Announcement: Mappable {
    
    public var text: String?
    public var id: String?
    public var timestamp: Date?
    public var image: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        text <- map["text"]
        id <- map["id"]
        image <- map["image"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        if let dateString = map["timestamp"].currentValue as? String, let date = dateFormatter.date(from: dateString) {
            timestamp = date
        }
        
    }

}
