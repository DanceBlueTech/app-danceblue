//
//  MasterRoster.swift
//  app-danceblue
//
//  Created by David Mercado on 11/13/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import ObjectMapper

class MasterRoster: Mappable {
    public var deviceUUId: String?
    public var individualPoints: Int?
    public var lastCheckin: String?
    public var linkBlue: String?
    public var memberName: String?
    public var teamName: String?
     
    required init?(map: Map) {}
    
    func mapping(map: Map) {
        deviceUUId <- map[kDeviceUUID]
        individualPoints <- map[kIndividualPoints]
        lastCheckin <- map[kLastCheckin]
        linkBlue <- map[kLinkBlue]
        memberName <- map[kMemberName]
        teamName <- map[kTeamName]
    }
    //might not need this
    func setMember(uuid: String, points: Int, lastCheck: String, link: String, fullName: String, TeamName: String){
        deviceUUId = uuid
        individualPoints = points
        lastCheckin = lastCheck
        linkBlue = link
        memberName = fullName
        teamName = TeamName
    }
 }
