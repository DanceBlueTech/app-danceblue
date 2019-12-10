//
//  constants.swift
//  app-danceblue
//
//  Created by David Mercado on 10/1/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation

// MARK: -constants for firebase names
let kFirebaseApp                = "app-danceblue"
let kMasterTeams                = "Master Teams"
let kTeamName                   = "Team Name"
let kTeamPoints                 = "Team Points"
let kMasterRoster               = "Master Roster"
let kDeviceUUID                 = "Device UUID"
let kIndividualPoints           = "Individual Points"
let kLastCheckin                = "Last Checkin"
let kLinkBlue                   = "LinkBlue"
let kMemberName                 = "Member Name"
let kOtherName                  = "OTHER"

// MARK: -GeoFence
let kGeoLocationName            = "name"
let kGeoLocationLat             = "latitude"
let kGeoLocationLong            = "longitude"
let kGeoLocationRadius          = "radius"
let kGeoFenceRadius             = 50.0
let kGeoFenceID                 = "DanceBlue_GeoFence"

//MARK: Contact Information from public website
let kContactInfoURL             = "http://www.danceblue.org/meet-the-team/"
let kFAQURL                     = "http://www.danceblue.org/frequently-asked-questions/"

// MARK: - Alerts
let kErrorTitle                 = "REQUIRED FIELDS!"
let kErrorTitle1                = "ERROR"
let kErrorTitle2                = "Warning"
let kErrorTitle3                = "CHECKIN FORBIDDEN!"
let kErrorMessage1              = "Geofencing is not supported on this device!"
let kErrorMessage2              = "You need to grant DanceBlue permission to access the device location, so you can check in to this event."
let kErrorMessage3              = "Monitoring failed for region with identifier: "
let kErrorMessage4              = "Location Manager failed with the following error: "
let kErrorMessage5              = "All fields are required in order to check in to this Event! Make sure you have selected the correct team and member name combination"
let kErrorMessage6              = "Something went wrong on our end. Please sign in manually for your Spirt Points. Thank you!"
let kErrorMessage7              = "Error Loading"
let kErrorMessage8              = "Member does NOT belong to this team! Please select another team"
let kErrorMessage9              = "Your Device has already been registered. Please select a valid member"
let kErrorMessage10             = "This Device has already checked into this Event!"
let kErrorMessage11             = "This Device ID does NOT match the Device ID for this member! Please select 'OTHER' and register yourself"

// MARK: Local Storage and date format
let kStoredUUIDKey              = "DeviceUUID"
let kDateFormat                 = "yyyy-MM-dd'T'HH:mm:ssZ"

// MARK: Segue
let kSegueCheckIn               = "goToCheckIn"
let kSegueFlyer                 = "FlyerSegue"
