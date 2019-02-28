//
//  Event.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 7/22/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import ObjectMapper

class Event: Mappable {
    
    public var month: String?
    public var points: String?
    public var title: String?
    public var description: String?
    public var time: String?
    public var id: String?
    public var timestamp: Date?
    public var endTime: Date?
    public var address: String?
    public var map: String?
    public var image: String?
    public var flyer: String?
    public var going: Int?
    public var category: String?
    
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        month <- map["month"]
        title <- map["title"]
        time <- map["time"]
        id <- map["id"]
        address <- map["address"]
        image <- map["image"]
        self.map <- map["map"]
        points <- map["points"]
        description <- map ["description"]
        flyer <- map["flyer"]
        going <- map["going"]
        category <- map["category"]
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        
        if let dateString = map["timestamp"].currentValue as? String, let date = dateFormatter.date(from: dateString) {
            timestamp = date
        }

        if let endDateString = map["endTime"].currentValue as? String, let date = dateFormatter.date(from: endDateString) {
            endTime = date
        }
    }

}
