//
//  EventsTableViewController.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 7/22/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import FirebaseAnalytics
import FirebaseDatabase
import UIKit

protocol EventsTableViewDelegate: class {
    func tableDidLoad()
}

class EventsTableViewController: UITableViewController {
    //TODO: HAVE FIREBASE HANDLES AND PULL TEAM ROSTER INFORMATION AND SAVE THEM
    //THEN PASS THEM INTO 'MARK - STORYBOARD' THIS WILL BE USED FOR DATE PICKER

    fileprivate var firebaseReference: DatabaseReference?
    private var thisWeekAddHandle: DatabaseHandle?
    private var comingUpAddHandle: DatabaseHandle?
    private var thisWeekchangeHandle: DatabaseHandle?
    private var comingUpChangeHandle: DatabaseHandle?
    private var thisWeekDeleteHandle: DatabaseHandle?
    private var comingUpDeleteHandle: DatabaseHandle?
    
    private var masterRosterHandle: DatabaseHandle?
    private var masterRosterChangeHandle: DatabaseHandle?
    private var masterTeamsHandle: DatabaseHandle?
    private var masterTeamsChangeHandle: DatabaseHandle?
    
    weak var delegate: EventsTableViewDelegate?
    private var thisWeekMap: [String : Event] = [:]
    private var comingUpMap: [String : Event] = [:]
    private var cellHeights: [[CGFloat]] = [[],[]]
    private var eventData: [[Event]] = [[],[]] {
        didSet {
            cellHeights[0] = [CGFloat].init(repeating: 0, count: eventData[0].count)
            cellHeights[1] = [CGFloat].init(repeating: 0, count: eventData[1].count)
        }
    }
    private var sectionData: [String] = ["THIS WEEK", "COMING UP"]
    
    private var masterRosterData : [MasterRoster] = []
    private var masterTeamsData : [MasterTeams] = []
    
    fileprivate var DeviceUUID: String = ""


    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupFirebase()
        checkStoredUUID()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        setUpNavigation(controller: navigationController, hidesBar: false)
        self.title = "Events"
        Analytics.logEvent("Events_List_Did_Appear", parameters: nil)
    }
    
    func setupTableView() {
        tableView.separatorInset = .zero
        tableView.separatorStyle = .none
        tableView.allowsSelection = true
        tableView.backgroundColor = Theme.Color.white
        setupRefreshControl()
    }
    
    func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = Theme.Color.black
        refreshControl.addTarget(self, action: #selector(refreshTable), for: .valueChanged)
        tableView.refreshControl = refreshControl
    }

    @objc func refreshTable() {
        refreshControl?.beginRefreshing()
        tableView.reloadData()
        
        // Since the database is realtime, reloading isn't necessary. However, while testing
        // users enjoy being able to check for updates by pulling down and seeing the loading
        // indicator for a second or two.
        DispatchQueue.main.asyncAfter(deadline: .now() + .seconds(1), execute: {
            self.tableView.refreshControl?.endRefreshing()
        })
    }
    
    // MARK: - TableView Data Source
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: EventTableViewCell.identifier, for: indexPath) as? EventTableViewCell {
            cell.configureCell(with: eventData[indexPath.section][indexPath.row])
            if cellHeights[indexPath.section][indexPath.row] == 0 {
               cellHeights[indexPath.section][indexPath.row] = cell.sizeThatFits(CGSize(width: tableView.bounds.width, height: .greatestFiniteMagnitude)).height
            }
            return cell
        }
        return EventTableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.section][indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return eventData[0].count
        } else {
            return eventData[1].count
        }
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return sectionData.count
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 46.0
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let header = EventsTableViewHeader(frame: CGRect(x: 0.0, y: 0.0, width: view.bounds.width, height: 46.0))
        header.configure(with: sectionData[section])
        return header
        
    }

    // MARK: - Storyboard
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let eventDetailsViewController = segue.destination as? EventDetailsViewController, segue.identifier == "EventSegue", let section = tableView.indexPathForSelectedRow?.section, let row = tableView.indexPathForSelectedRow?.row {
            eventDetailsViewController.event = eventData[section][row]
            eventDetailsViewController.masterRoster = masterRosterData
            eventDetailsViewController.masterTeams = masterTeamsData

            //eventDetailsViewController.delegate = self      // Used for "liking" of events
        }
    }
    
    // MARK: - Utility 
    
    func sortEvents(section: Int) {
        eventData[section].sort(by: {$0.timestamp ?? Date() < $1.timestamp ?? Date()})
    }
    /*
    func sortMasterRoster() {
        eventData[section].sort(by: {$0.timestamp ?? Date() < $1.timestamp ?? Date()})
    }
    func sortMasterTeams() {
        eventData[section].sort(by: {$0.timestamp ?? Date() < $1.timestamp ?? Date()})
    }*/
    
    // MARK: - Firebase
    
    func setupFirebase() {
        
        firebaseReference = Database.database().reference()
        
        // This Week Handles
        
        thisWeekAddHandle = firebaseReference?.child("events").child("thisWeek").observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let event = Event(JSON: data) else { return }
            self.thisWeekMap[event.id ?? ""] = event
            self.eventData[0].append(event)
            self.sortEvents(section: 0)
            self.tableView.reloadData()
            self.delegate?.tableDidLoad()
        })
        
        thisWeekchangeHandle = firebaseReference?.child("events").child("thisWeek").observe(.childChanged, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let event = Event(JSON: data) else { return }
            self.thisWeekMap.updateValue(event, forKey: event.id ?? "")
            self.eventData[0] = Array(self.thisWeekMap.values)
            self.sortEvents(section: 0)
            self.tableView.reloadData()
        })
        
        thisWeekDeleteHandle = firebaseReference?.child("events").child("thisWeek").observe(.childRemoved, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let event = Event(JSON: data) else { return }
            self.thisWeekMap.removeValue(forKey: event.id ?? "")
            self.eventData[0] = Array(self.thisWeekMap.values)
            self.sortEvents(section: 0)
            self.tableView.reloadData()
        })
        
        // Coming Up Handles
        
        comingUpAddHandle = firebaseReference?.child("events").child("comingUp").observe(.childAdded, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let event = Event(JSON: data) else { return }
            self.comingUpMap[event.id ?? ""] = event
            self.eventData[1].append(event)
            self.sortEvents(section: 1)
            self.tableView.reloadData()
            self.delegate?.tableDidLoad()
        })
        
        comingUpChangeHandle = firebaseReference?.child("events").child("comingUp").observe(.childChanged, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let event = Event(JSON: data) else { return }
            self.comingUpMap.updateValue(event, forKey: event.id ?? "")
            self.eventData[1] = Array(self.comingUpMap.values)
            self.sortEvents(section: 1)
            self.tableView.reloadData()
        })
        
        comingUpDeleteHandle = firebaseReference?.child("events").child("comingUp").observe(.childRemoved, with: { (snapshot) in
            guard let data = snapshot.value as? [String : AnyObject]  else { return }
            guard let event = Event(JSON: data) else { return }
            self.comingUpMap.removeValue(forKey: event.id ?? "")
            self.eventData[1] = Array(self.comingUpMap.values)
            self.sortEvents(section: 1)
            self.tableView.reloadData()
        })
        
        // Master Roster Handles
        
        masterRosterHandle = firebaseReference?.child(kMasterRoster).observe(.childAdded, with: { (snapshot) in
            //print("snapshot for MasterRoster: \(snapshot)")
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            //print("data: \(data)")
            guard let masterRoster = MasterRoster(JSON: data) else { return }
            self.masterRosterData.append(masterRoster)
            //print("masterRosterData Count: \(self.masterRosterData.count)")
            //CALL SORT FUNCION...SORT BY --> PRIMARY NAME, SECONDARY TEAMS...MAYBE SWITCH PRIME AND SECONDARY
        })
        
        // Master Teams Handles
        
        masterTeamsHandle = firebaseReference?.child(kMasterTeams).observe(.childAdded, with: { (snapshot) in
            //print("snapshot for MasterTeams: \(snapshot)")
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            //print("data: \(data)")
            guard let masterTeams = MasterTeams(JSON: data) else { return }
            self.masterTeamsData.append(masterTeams)
            //print("masterTeamsData Count: \(self.masterTeamsData.count)")
            //CALL SORT FUNCION...SORT BY --> PRIMARY TEAMS...MAYBE SWITCH TO POINTS?

        })
    }
    
    // MARK: - Local Storage Device UUID
    func checkStoredUUID(){
        guard let storedData = UserDefaults.standard.array(forKey: kStoredUUIDKey) as? [Data] else {
            print("No Stored UUID Data!")
            //initUUID()
            return
        }
        
        for itemData in storedData {
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: itemData) else{ continue }
            DeviceUUID = item as! String
            print("Stored Device UUID: \(DeviceUUID)")
            //setDeviceUUID(uuid: item as! String)
        }
    }
}
