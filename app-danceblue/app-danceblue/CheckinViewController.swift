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

//TODO: PASS IN CURRENT EVENT'S POINTS TO THIS VIEW CONTROLLER AND APPEND THE POINT(S)
//  TO THE FIREBASE PUSH/UPDATE
#warning("FIX ME")
class CheckinViewController: UIViewController {
    
    var eventTitle: String = ""
    var eventCoords: CLLocationCoordinate2D = CLLocationCoordinate2D()
    var eventPoints: Int = 0
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
    @IBOutlet weak var directionsLabel: UILabel!
    
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
    
    @IBAction func CancelTapped(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
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
    
    #warning("Make all firebase calls its own gloabal class with completion handlers")
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
    // TODO: make this more compact and dynamic!
    //used to update current values of existing member
    func UpdateFirebase(uuid: String, points: Int, lastCheck: String){
        firebaseReference = Database.database().reference()
        //var path = firebaseReference?.child(kFirebaseApp).child(kMasterRoster).queryOrdered(byChild: uuid).
        
        //var query = firebaseReference?.child(kFirebaseApp).child(kMasterRoster).orderByChild("uid").equalTo(uuid);
        /*query.once("child_added", function(snapshot) {
            snapshot.ref.update({ kLastCheckin: lastCheck, kIndividualPoints: points})
        });
        
        let ref = FIRDatabase.database().reference().child("users/90384m590v834dfgok34")

        ref.updateChildValues([
            "values": [
                "test3",
                "test4"
            ]
        ])*/
    }
    
    // TODO: make this more compact and dynamic!
    // used to Add new Membersmake this more compact and dynamic!
    func AddToFirebase(uuid: String, points: Int, lastCheck: String, link: String, fullName: String, TeamName: String) {
        firebaseReference = Database.database().reference()
        let id:String? = firebaseReference?.child(kFirebaseApp).child(kMasterRoster).childByAutoId().key
        firebaseReference?.child(kMasterRoster).child(id!).child(kDeviceUUID).setValue(uuid)
        firebaseReference?.child(kMasterRoster).child(id!).child(kIndividualPoints).setValue(points)
        firebaseReference?.child(kMasterRoster).child(id!).child(kLastCheckin).setValue(lastCheck)
        firebaseReference?.child(kMasterRoster).child(id!).child(kLinkBlue).setValue(link)
        firebaseReference?.child(kMasterRoster).child(id!).child(kMemberName).setValue(fullName)
        firebaseReference?.child(kMasterRoster).child(id!).child(kTeamName).setValue(TeamName)
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
                
                #warning("FIX THIS logic-> Test Case:")
                /*
                 what happens when master roster is initally populated with only the team captin and no Device UUID (it will force the member to register their device under the member name 'OTHER' thus never being able to use the original team captin name)?? My suggestion is to not populate the master roster at the beginning just leave the default member 'OTHER' and have each user populate their own information. The app will push everything needed to firebase!
                */
                
                //The Device UUID is Not registered under the selected member name
                if(!isRegistered){
                    //if the current member has Not checked into this event
                    if(!isCheckedin){
                        print("This member is valid to start the geoFence process") //debugging purposes
                        
                        //startMonitoring() --> geofence
                        
                        //make sure they check into the geo fence before adding information to firebase!
                        #warning("make sure firebase successfully stores and updates without error before moving forward ")
                        
                        //new total for individual points
                        let memberTotal = eventPoints + (masterRosterDICT[nameField]?.individualPoints ?? 0)
                        //master Roster: update individual points for current device UUID (points + spirit points for current event), update last checkin to eventTitle
                        //master Teams: update team points (points + spirit points for current event)
                        
                        #warning("There might be an issue if multiple users try to update team points at the same time...might be better idea if on the back end the teams add up their points from the memebrs individual points themselves!!")
                        
                        //TODO: wait for geoFence to check in before sending data to firebase--> needs a completeion handler
                        //send device uuid, individual points, last checked, link blue  member name, and team name
                        //UpdateToFirebase(uuid: DeviceUUID, points: memberTotal, lastCheck: eventTitle)
                        
                        //TODO: dismiss CheckinView Controller after information is added to firebase--> needs a completion handler
                        //need to wait for geoFence to complete and firebase to finish before dismissing
                        self.dismiss(animated: true, completion: nil)
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

                    var isDeviceRegistered = false
                    var fbDeviceUUId = ""
                    //checking to see if the Device's UUID is already registered in firebase. Dont allow them to register with another name!!
                    for (_, value) in masterRosterDICT {
                        fbDeviceUUId = value.deviceUUId ?? ""
                        if(fbDeviceUUId == DeviceUUID){
                            isDeviceRegistered = true
                            break;
                        }
                    }
                    print("members fbDeviceUUId: \(fbDeviceUUId) isDeviceRegistered: \(isDeviceRegistered) ")    //debugging purposes
                    
                    //if current Device UUID has Not been registered to firebase
                    if(!isDeviceRegistered){
    
                        print("This member is valid to start the geoFence process") //debugging purposes

                         //startMonitoring()
                     
                        //make sure they check into the geo fence before adding information to firebase!
                         #warning("make sure firebase successfully stores and updates without error before moving forward ")
                        
                        /* TODO: make new function in master Roster in order to init a new object and just pass the object to AddToFirebase() and redo the code in that function in order to reduce lines of code and make it more dynamic
                         
                         var newMember : MasterRoster
                        newMember.setMember(uuid: DeviceUUID, points: eventPoints, lastCheck: eventTitle, link: linkBlueField, fullName: fullNameField, TeamName: teamField)
                        AddToFirebase(newMember)*/
                        
                        //TODO: wait for geoFence to check in before sending data to firebase--> needs a completeion handler
                        //send device uuid, individual points, last checked, link blue  member name, and team name
                        AddToFirebase(uuid: DeviceUUID, points: eventPoints, lastCheck: eventTitle, link: linkBlueField, fullName: fullNameField, TeamName: teamField)
                        
                        //TODO: dismiss CheckinView Controller after information is added to firebase--> needs a completion handler
                        //need to wait for geoFence to complete and firebase to finish before dismissing
                        self.dismiss(animated: true, completion: nil)
                     }
                     else{
                        showAlert(withTitle: kErrorTitle2, message: kErrorMessage9)
                     }
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
            showAlert(withTitle: kErrorTitle, message: kErrorMessage5)
        }
    }
    
    #warning("Make all GeoFence related items into its own gloabal class, with completetion handelers")
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
                directionsLabel.isHidden = false
            }
            else{
                linkBlueTextField.isHidden = true
                fullnameTextField.isHidden = true
                directionsLabel.isHidden = true
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
