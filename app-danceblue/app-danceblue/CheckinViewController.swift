//
//  CheckinViewController.swift
//  app-danceblue
//
//  Created by David Mercado on 11/16/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import FirebaseDatabase
import UIKit
import CoreLocation

//might not need
protocol GeoFenceDelegate: class {
    func checkInGeoFence()
}
//might not need
protocol GeoFenceDelegate2 {
    func CheckInGeoFence(_ controller: CheckinViewController, x: String)
}

#warning("FIX ME")
class CheckinViewController: UIViewController {
    
    fileprivate var DeviceUUID: String = ""
    fileprivate var firebaseReference: DatabaseReference?
    private var masterRosterHandle: DatabaseHandle?
    private var masterRosterUpdateHandle: DatabaseHandle?
    private var masterTeamsHandle: DatabaseHandle?
    //private var masterTeamsUpdateHandle: DatabaseHandle?
    private var masterRosterData : [MasterRoster] = []
    private var masterTeamsData : [MasterTeams] = []
    
    //Dictonary and arrays from master teams and master roster in firebase
    var masterTeamDICT: [String: Int] = [:]
    var masterRosterDICT: [String: MasterRoster] = [:]
    var teamNamesARRAY = [String]()  //array of team names from dictonary of masterTeams
    var teamPointsARRAY = [Int]()   //array of team points from dictonary of masterTeams
    var memberNamesARRAY = [String]()   //array of member names from dictonary of masterRoster
    var memberProfileARRAY = [MasterRoster]() //array of member profiles from dictonary of masterRoster
    //var dictTEAMKeys = [String]()
    //var dictTEAMValues = [Int]()
    //var dictROSTERKeys = [String]()
    //var dictROSTERValues = [MasterRoster]()
    var currentEventTitle: String?
    var selectedTeam: String?
    var selectedName: String?
    var textfieldFlag: Bool = false
    weak var checkInDelegate: GeoFenceDelegate?
    var CHECK_InDelegate: GeoFenceDelegate2!
    
    // GeoFencing variables
    let locationManager = CLLocationManager()
    var coordinates = CLLocationCoordinate2D()

    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var linkBlueTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    
    // MARK: - Initialization---------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.requestAlwaysAuthorization()
        
        //linkBlueTextField.isHidden = true
        //fullnameTextField.isHidden = true

        createTeamPicker()
        createNamePicker()
        //createToolBar()
        
        setupFirebase()
        checkStoredUUID()
    }
    
    // MARK: - custom UIPicker for master teams---------------------------------
    func createTeamPicker(){
        let teamPicker = UIPickerView()
        teamPicker.delegate = self
        teamPicker.tag = 0
        teamTextField.inputView = teamPicker
    }
    
    // MARK: - custom UIPicker for master roster--------------------------------
    func createNamePicker(){
        let namePicker = UIPickerView()
        namePicker.delegate = self
        namePicker.tag = 1
        nameTextField.inputView = namePicker
    }
    
    // MARK: - Firebase---------------------------------------------------------
    func setupFirebase() {
        firebaseReference = Database.database().reference()
        
        // Master Roster Handles
        masterRosterHandle = firebaseReference?.child(kMasterRoster).observe(.childAdded, with: { (snapshot) in
            //print("snapshot for MasterRoster: \(snapshot)")
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            guard let masterRoster = MasterRoster(JSON: data) else { return }
            self.masterRosterData.append(masterRoster)
            //print("masterRosterName: \(self.masterRosterData.last!.memberName) masterRoster \(self.masterRosterData.last!.teamName)")
            self.masterRosterDICT[self.masterRosterData.last!.memberName ?? ""] = self.masterRosterData.last!
            //print("masterRosterDICT: \(self.masterRosterDICT)")
        })
        
        // Master Teams Handles
        masterTeamsHandle = firebaseReference?.child(kMasterTeams).observe(.childAdded, with: { (snapshot) in
            //print("snapshot for MasterTeams: \(snapshot)")
            guard let data = snapshot.value as? [String : AnyObject] else { return }
            guard let masterTeams = MasterTeams(JSON: data) else { return }
            self.masterTeamsData.append(masterTeams)
            //print("masterTeamName: \(self.masterTeamsData.last!.teamName) team points \(self.masterTeamsData.last!.teamPoints)")
            self.masterTeamDICT[self.masterTeamsData.last!.teamName ?? ""] = self.masterTeamsData.last!.teamPoints
            //print("masterTeamsDict: \(self.masterTeamDict)")
        })
    }
    
    #warning("FIX ME")
    func UpdateFirebase(){
        
    }
    #warning("FIX ME")
    func AddToFirebase() {
        let ref = Database.database().reference(withPath: kMasterRoster)
        let post = ["TEST": "11111111"]
        //ref.child("TEST").setValue(post)
        /*ref.observe(.value, with: {snapshot in
            var newItems: [MasterRoster] = []
            for child in snapshot.children{
                if let snapshot = child as? DataSnapshot
                    print(snapshot)
                }
            }
        })*/
        //firebaseReference = Database.database().reference()
        /*guard let key = firebaseReference?.child(kMasterRoster).childByAutoId().key else { return }
        let post = [kDeviceUUID: uuid,
                    kIndividualPoints: points,
                    kMemberName: memberName,
                    kTeamName: teamName]
        let childUpdates = ["/posts/\(key)": post,
                            "/user-posts/\(userID)/\(key)/": post]
        firebaseReference.updateChildValues(childUpdates)
        */
   /* firebaseReference.child(kMasterRoster).child(user.uid).setValue(["username": username]) {
          (error:Error?, ref:DatabaseReference) in
          if let error = error {
            print("Data could not be saved: \(error).")
          } else {
            print("Data saved successfully!")
          }
        }*/
        
        //masterRosterUpdateHandle = firebaseReference?.child(<#T##pathString: String##String#>)
    }
    
    #warning("TEST ME- something errored out on very first app luanch ever, might be an async thing")
    // MARK: - Local Storage Device UUID----------------------------------------
    func checkStoredUUID(){
        guard let storedData = UserDefaults.standard.array(forKey: kStoredUUIDKey) as? [Data] else {
            print("No Stored UUID Data, time to init one")
            initUUID()
            return
        }
        
        for itemData in storedData {
            guard let item = NSKeyedUnarchiver.unarchiveObject(with: itemData) else{ continue }
            setDeviceUUID(uuid: item as! String)
        }
    }
    func initUUID() {
        self.DeviceUUID = UUID().uuidString
        print("This is the Devices' UUID init: \(DeviceUUID)")
        storeUUID()
    }
    func setDeviceUUID(uuid: String) {
        self.DeviceUUID = uuid
        print("This is the Devices' UUID in local storage: \(DeviceUUID)")
    }
    func storeUUID() {
        var itemsData = [Data]()
        let itemData = NSKeyedArchiver.archivedData(withRootObject: self.DeviceUUID)
        itemsData.append(itemData)
        UserDefaults.standard.set(itemsData, forKey: kStoredUUIDKey)
        UserDefaults.standard.synchronize()
    }
    
    #warning("FIX ME")
    // MARK: - Comfirm Checkin Button-------------------------------------------
    @IBAction func confirmCheckIn(_ sender: Any) {
        let teamField = String(teamTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        let nameField = String(nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        let isTeamFieldEmpty  = teamField.isEmpty
        let isNameFieldEmpty = nameField.isEmpty
        
        print("team: \(teamField) isEmpty: \(teamField.isEmpty)")
        print("name: \(nameField) isEmpty: \(nameField.isEmpty)")
        
        //TODO: make sure member is in team roster other wise display alert
        //the only exception is if member name == 'other'
        //TODO: make sure to check if the current member has already checked into this event if so display and alert saying thye have already checked in
        
        //when team and name fields are valid
        if(!isTeamFieldEmpty && !isNameFieldEmpty){
            print("both are not empyt")
            print("linkBlueTextField.isHidden: \(linkBlueTextField.isHidden)")
            print("fullnameTextField.isHidden: \(fullnameTextField.isHidden)")
            
            /*TODO: if 'other' is selected for member then check that linkblue and fullname text fields are filled out
             if() {
                //send device uuid, member name, link blue, team name, points
                //Update Firebase database()

             }else {
                showAlert(withTitle: kErrorTitle, message: kErrorMessage5)
                return
             }
            */
            
            startMonitoring()
            #warning("make sure firebase successfully stores and updates without error before moving forward ")
            //AddToFirebase()
        }
        else{
            print("something is empty")
            print("linkBlueTextField.isHidden: \(linkBlueTextField.isHidden)")
            print("fullnameTextField.isHidden: \(fullnameTextField.isHidden)")
            //AddToFirebase()     //debugging
            showAlert(withTitle: kErrorTitle, message: kErrorMessage5)
        }
        //checkInDelegate?.checkInGeoFence()   //pass in event lat, long
        
        //CHECK_InDelegate.CheckInGeoFence(self, x: "Hello World!")
        //self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - GeoFence---------------------------------------------------------
    
    // MARK: - Start monitoring the geofence region-------------------
    func startMonitoring(){
        let clampedRadius = min(kGeoFenceRadius, locationManager.maximumRegionMonitoringDistance)
        //TODO: make this the coordinates of the current event
        //let coordinate = CLLocationCoordinate2D.init()
        print("starting to Monitor; coords are: \(coordinates)")
        let geoLocation = Geotification(coordinate: coordinates, radius: clampedRadius)
        
        // geofencing is not supported on this device
        //TODO: if this failes makes sure it returns back to the pervious view controller
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle: kErrorTitle1, message: kErrorMessage1)
            return
        }
        // geofencing does not have permissions
        //TODO:-->make sure to not allow submission to firebase until permission is granted
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:kErrorTitle2, message: kErrorMessage2)
        }

        //storing the GeoFence region
        let fenceRegion = region(with: geoLocation)
        
        //Starts monitoring the specified region
        //might replace with startMonitoringVisits()
        locationManager.startMonitoring(for: fenceRegion)
        
        //TODO:: keep checking to see if user is in region and then call stop monitoring
        //look at CLLocationManager member functions for this maybe...func requestState(for region: CLRegion)
        
        //might replace with stopMonitoringVisits()
        stopMonitoring(geotification: geoLocation)
    }
    
    // MARK: - Set up geofence region---------------------------------
    func region(with geotification: Geotification) -> CLCircularRegion {
        // init a region from the current event's coordinates
        let region = CLCircularRegion(center: geotification.coordinate,
        radius: geotification.radius,
        identifier: geotification.identifier)
        
        // not sure if we need this
        //region.notifyOnEntry = (geotification.eventType == .onEntry)
        //region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    // MARK: - Stop monitoring the Geofence regions-------------------
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion,
                circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }
}

// MARK: - passing current event information------------------------------------
extension CheckinViewController: EventCoordinatesDelegate {
    //TODO: add param for event title
    func updateCoords(currentEventTitle: String, coordinates: CLLocationCoordinate2D){
        print("I passed my data!!!")
        self.currentEventTitle = currentEventTitle
        self.coordinates = coordinates
        print("coords: \(coordinates)")
    }
}

// MARK: - Date picker for master roster and master teams-----------------------
extension CheckinViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        //let teamArray = [String](masterTeamDICT.keys)
        //let dictValues = [Int](masterTeamDICT.values)
        //let memberArray = [String](masterRosterDICT.keys)
        
        teamNamesARRAY = [String](masterTeamDICT.keys)
        teamPointsARRAY = [Int](masterTeamDICT.values)
        memberNamesARRAY = [String](masterRosterDICT.keys)
        memberProfileARRAY = [MasterRoster](masterRosterDICT.values)
        
        if(pickerView.tag == 0){
            self.view.endEditing(true)
            return teamNamesARRAY.count

        }
        else if(pickerView.tag == 1){
            self.view.endEditing(true)
            return memberNamesARRAY.count
        }
        else{return 0}
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        //let teamArray = [String](masterTeamDICT.keys)
        //let dictValues = [Int](masterTeamDICT.values)
        //var memberArray = [String](masterRosterDICT.keys)
        memberNamesARRAY.sort(by: {$0 < $1})
        
        if(pickerView.tag == 0){
            self.view.endEditing(true)
            return teamNamesARRAY[row]
        }
        else if(pickerView.tag == 1){
            self.view.endEditing(true)
            return memberNamesARRAY[row]
        }
        else{
            self.view.endEditing(true)
            return kErrorMessage7
        }
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //let teamArray = [String](masterTeamDICT.keys)
        //let dictValues = [Int](masterTeamDICT.values)
        //let memberArray = [String](masterRosterDICT.keys)
        
        if(pickerView.tag == 0){
            selectedTeam = teamNamesARRAY[row]
            teamTextField.text = selectedTeam
        }
        else if(pickerView.tag == 1){
            selectedName = memberNamesARRAY[row]
            nameTextField.text = selectedName
            
            if(selectedName == kOtherName){
                linkBlueTextField.isHidden = false
                fullnameTextField.isHidden = false
            }
            else{
                linkBlueTextField.isHidden = true
                fullnameTextField.isHidden = true
            }
        }
        self.view.endEditing(true)
    }
}

// MARK: - Location Manager Delegate--------------------------------------------
extension CheckinViewController: CLLocationManagerDelegate {
  
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    let errorMessage = "\(kErrorMessage3) + \(region!.identifier)"
    print(errorMessage) //debugging
    showAlert(withTitle: kErrorTitle1, message: errorMessage)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    let errorMessage = "\(kErrorMessage4) + \(error)"
    print(errorMessage) //debugging
    showAlert(withTitle: kErrorTitle1, message: errorMessage)
  }
}
