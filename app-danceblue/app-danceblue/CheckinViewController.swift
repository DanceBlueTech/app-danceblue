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

/*
//might not need
protocol GeoFenceDelegate: class {
    func checkInGeoFence()
}
//might not need
protocol GeoFenceDelegate2 {
    func CheckInGeoFence(_ controller: CheckinViewController, x: String)
}*/

#warning("FIX ME")
class CheckinViewController: UIViewController {
    
    var eventTitle: String = ""
    var eventCoords: CLLocationCoordinate2D = CLLocationCoordinate2D()
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
    var masterDeviceUUID_DICT: [String: MasterRoster] = [:]
    var teamNamesARRAY = [String]()  //array of team names from dictonary of masterTeams
    var teamPointsARRAY = [Int]()   //array of team points from dictonary of masterTeams
    var memberNamesARRAY = [String]()   //array of member names from dictonary of masterRoster
    var memberProfileARRAY = [MasterRoster]() //array of member profiles from dictonary of masterRoster
    //var dictTEAMKeys = [String]()
    //var dictTEAMValues = [Int]()
    //var dictROSTERKeys = [String]()
    //var dictROSTERValues = [MasterRoster]()
    
    var selectedTeam: String?
    var selectedName: String?
    var linkBlueField: String = ""
    var fullNameField: String = ""

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
        print("inside CheckinViewController!!")             //debugging
        print("Current Event title: \(eventTitle)")         //debugging
        print("Current Event Coordinates: \(eventCoords)")  //debugging

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
            //self.masterDeviceUUID_DICT[self.masterRosterData.last!.deviceUUId ?? ""] = self.masterRosterData.last!
            //print("masterRosterDICT: \(self.masterRosterDICT)")
            //print("masterDeviceUUID_DICT: \(self.masterDeviceUUID_DICT) length: \(self.masterDeviceUUID_DICT.count)")
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
        firebaseReference = Database.database().reference()
        let id:String? = firebaseReference?.child("app-danceblue").child(kMasterRoster).childByAutoId().key
        //let post = [kDeviceUUID: DeviceUUID,
          //          kIndividualPoints: 1,
            //        kMemberName: memberName,
              //      kTeamName: teamName]
        
        firebaseReference?.child(id!).child("Device UUID").setValue(DeviceUUID)
        firebaseReference?.child(id!).child("Individual Points").setValue(1)
        firebaseReference?.child(id!).child("Last Checkin").setValue("TEST EVENT")
        firebaseReference?.child(id!).child("LinkBlue").setValue("TEST LINKBLUE")
        firebaseReference?.child(id!).child("Member Name").setValue("TEST NAME")
        firebaseReference?.child(id!).child("Team Name").setValue("TEST TEAM")
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
        
        //checking team and member names
        let teamField = String(teamTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        let nameField = String(nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        let isTeamFieldEmpty = teamField.isEmpty
        let isNameFieldEmpty = nameField.isEmpty
        
        // Team and name fields are Not empty
        if(!isTeamFieldEmpty && !isNameFieldEmpty){
            
            //debugging purposes
            print("teamField: \(teamField)")
            print("nameField: \(nameField)")
            
            //checking to see if member is part of team
            let membersTeam = masterRosterDICT[nameField]?.teamName ?? ""
            var isMember = false
            if(membersTeam == teamField){isMember = true}
            print("members Team: \(membersTeam) ismember: \(isMember) ")    //debugging purposes
            
            //member is in team roster
            if(isMember){
             
                //checking to see if the Devices UUID is registered
                let deviceRegistered = masterRosterDICT[nameField]?.deviceUUId ?? ""
                var isRegistered = false
                if(deviceRegistered == DeviceUUID){isRegistered = true}
                print("members deviceRegistered: \(deviceRegistered) isRegistered: \(isRegistered) ")    //debugging purposes
                
                // checking to see if members name last check in was this event
                let lastCheckin = masterRosterDICT[nameField]?.lastCheckin ?? ""
                var isCheckedin = false
                if(lastCheckin == eventTitle){isCheckedin = true}
                print("members lastCheckin: \(lastCheckin) isCheckedin: \(isCheckedin) ")    //debugging purposes
                
                //The Device UUID is Not registered under the selected member name
                if(!isRegistered){
                    //if the current member has Not checked into this event
                    if(!isCheckedin){
                        print("This member is valid to start the geoFence process")
                        //startMonitoring()
                        
                        //make sure they check into the geo fence before adding information to firebase!
                        #warning("make sure firebase successfully stores and updates without error before moving forward ")
                        
                        //master Roster: update individual points for current device UUID (points + spirit points for current event), update last checkin to eventTitle
                        //master Teams: update team points (points + spirit points for current event)
                 
                        #warning("There might be an issue if multiple users try to update team points at the same time...might be better idea if on the back end the teams add up their points from the memebrs individual points themselves!!")
                        //UpdateToFirebase()
                        
                        //dismiss CheckinView Controller after information is added to firebase
                    }
                    else{
                        showAlert(withTitle: kErrorTitle3, message: kErrorMessage10)
                    }
                }
                else{
                    showAlert(withTitle: kErrorTitle3, message: kErrorMessage11)
                }
             }
             //if the selected member is 'OTHER'
            if(selectedName == kOtherName){
                
                // checking linkBlue and full name
                linkBlueField = String(linkBlueTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                fullNameField = String(fullnameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
                let isLinkFieldEmpty = linkBlueField.isEmpty
                let isFullNameFieldEmpty = fullNameField.isEmpty
                
                print("linkBlueField: \(linkBlueField) isEmpty: \(isLinkFieldEmpty)")
                print("fullNameField: \(fullNameField) isEmpty: \(isFullNameFieldEmpty)")
                
                // linkBlue and Fullname are Not empty
                if(!isLinkFieldEmpty && !isFullNameFieldEmpty){
                    print("linkBlueField: \(linkBlueField)")
                    print("fullNameField: \(fullNameField)")
                    //if the Current Device's UUID already exisits in firebase. Dont allow them to register with another name!!
                    
                    //if current Device UUID hasnt been registered to firebase
                     /*if(Current DeviceUUID != exist in firebase DeviceUUID){
                     
                         //startMonitoring()
                     
                        //make sure they check into the geo fence before adding information to firebase!
                         #warning("make sure firebase successfully stores and updates without error before moving forward ")
                     
                        //send device uuid, individual points, last checked, link blue  member name, and team name
                        //AddToFirebase()
                     
                        //dismiss CheckinView Controller after information is added to firebase
                     }
                     else{
                        showAlert(withTitle: kErrorTitle2, message: kErrorMessage9)
                     }
                     */
                }
                else{
                    showAlert(withTitle: kErrorTitle, message: kErrorMessage5)
                }
             }
            else{
                showAlert(withTitle: kErrorTitle2, message: kErrorMessage8)
            }
        }
        else{
            print("Team Field or Member Field is empty")    //debugging purposes
            showAlert(withTitle: kErrorTitle, message: kErrorMessage5)
        }
        //self.dismiss(animated: true, completion: nil)
    }
    
    // MARK: - GeoFence---------------------------------------------------------
    
    // MARK: - Start monitoring the geofence region-------------------
    func startMonitoring(){
        let clampedRadius = min(kGeoFenceRadius, locationManager.maximumRegionMonitoringDistance)
        //TODO: make this the coordinates of the current event
        //let coord = CLLocationCoordinate2D.init()
        //print("starting to Monitor; coords are: \(coord)")
        //let geoLocation = Geotification(coordinate: coord, radius: clampedRadius)
        print("starting to Monitor coords are: \(eventCoords)")
        let geoLocation = Geotification(coordinate: eventCoords, radius: clampedRadius)
        
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

//TODO: append member name and link blue for better selection then display them
//in the master roster UI picker
// MARK: - UI picker for master roster and master teams-----------------------
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
            return teamNamesARRAY.count

        }
        else if(pickerView.tag == 1){
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
            return teamNamesARRAY[row]
        }
        else if(pickerView.tag == 1){
            return memberNamesARRAY[row]
        }
        else{
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
