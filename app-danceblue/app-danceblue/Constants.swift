//
//  constants.swift
//  app-danceblue
//
//  Created by David Mercado on 10/1/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation

// MARK: -constants for firebase names
let kMasterTeams                = "Master Teams"
let kTeamName                   = "Team Name"
let kTeamPoints                 = "Team Points"
let kMasterRoster               = "Master Roster"
let kDeviceUUID                 = "Device UUID"
let kIndividualPoints           = "Individual Points"
let kLinkBlue                   = "LinkBlue"
let kMemberName                 = "Member Name"

let kGeoLocationTableName       = "geolocation"
let kGeoLocationName            = "name"
let kGeoLocationLat             = "latitude"
let kGeoLocationLong            = "longitude"
let kGeoLocationRadius          = "radius"

//MARK: Contact Information from public website
let kContactInfoURL             = "http://www.danceblue.org/meet-the-team/"
let kFAQURL                     = "http://www.danceblue.org/frequently-asked-questions/"

// MARK: - Alerts
let kError1                     = "ERROR"
let kError2                     = "Warning"
let kErrorMessage1              = "Geofencing is not supported on this device!"
let kErrorMessage2              = "Your geotification is saved but will only be activated once you grant Geotify permission to access the device location."
let kErrorMessage3              = "Monitoring failed for region with identifier: "
let kErrorMessage4              = "Location Manager failed with the following error: "
let kErrorTitle                 = "REQUIRED FIELDS!"
let kErrorMessage5              = "All fields are required in order to check in to this Event! Make sure you have selected the correct team and member name combination"
// MARK: local storage
let kStoredUUIDKey              = "DeviceUUID"
