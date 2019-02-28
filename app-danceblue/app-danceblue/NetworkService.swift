//
//  NetworkService.swift
//  app-danceblue
//
//  Created by Skye Brown on 2/7/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreData

class NetworkService {
    static let instance = NetworkService()
    
    var teams = [Team]()
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    // http request to populate teams array with teams
    func getTeams() {
        Alamofire.request("http://10.47.196.102:8000/api/getTeamNames").responseJSON { (response) in
            //            print(response)
            guard let data = response.data else {
                print("failed response.data")
                return
            }
            //            print(data)
            do {
                let jsonResponse = try JSON(data: data)
                guard let jsonData = jsonResponse["teams"].array else {
                    print("failed JSON(data: data)")
                    return
                }
                print("JSON data: ", jsonData)
                
                for teamData in jsonData {
                    print("Team data: ", teamData)
                    if let teamName = teamData["teamName"].string,
                        let teamID = teamData["id"].int {
                        //let team = Team(teamName: teamName, uid: String(teamID))
                        
                        // CREATE A NEW TEAM - NSManagedObject
                        let team = Team(context: self.context)
                        team.teamName = teamName
                        team.uid = String(teamID)
                        self.teams.append(team)
                        print("Team count: ", self.teams.count)
                    }
                }
                // save all teams into core data
                self.saveIntoCoreData()
            } catch {
                print("error trying to print JSON data: \(error)")
            }
        }
    }
    
    // fetches teams from core data
    func loadCoreDataTeams() {
        let request: NSFetchRequest<Team> = Team.fetchRequest()
        do {
            teams = try context.fetch(request)
        } catch {
            print("Error retrieving teams from core data: \(error)")
        }
    }
    
    // saves local data into core data
    func saveIntoCoreData() {
        do {
            try context.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}
