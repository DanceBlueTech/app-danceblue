//
//  MasterTeams.swift
//  app-danceblue
//
//  Created by David Mercado on 11/13/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import ObjectMapper

class MasterTeams: Mappable {
    public var teamName : String?
    public var teamPoints : Int?

    required init?(map: Map) {}

    func mapping(map: Map) {
        teamName <- map[kTeamName]
        teamPoints <- map[kTeamPoints]
    }
}
