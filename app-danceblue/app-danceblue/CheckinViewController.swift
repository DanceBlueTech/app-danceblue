//
//  CheckinViewController.swift
//  app-danceblue
//
//  Created by David Mercado on 11/16/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import FirebaseDatabase
import UIKit

class CheckinViewController: UIViewController{
    
    fileprivate var DeviceUUID: String = ""
    fileprivate var firebaseReference: DatabaseReference?
    private var masterRosterHandle: DatabaseHandle?
    private var masterRosterUpdateHandle: DatabaseHandle?
    private var masterTeamsHandle: DatabaseHandle?
    //private var masterTeamsUpdateHandle: DatabaseHandle?
    private var masterRosterData : [MasterRoster] = []
    private var masterTeamsData : [MasterTeams] = []
    var masterTeamDICT: [String: Int] = [:]
    var masterRosterDICT: [String: MasterRoster] = [:]
    
    var dictTEAMKeys = [String]()
    var dictTEAMValues = [Int]()
    var dictROSTERKeys = [String]()
    var dictROSTERValues = [MasterRoster]()
    var selectedTeam: String?
    var selectedName: String?
    var textfieldFlag: Bool = false
    
    @IBOutlet weak var teamTextField: UITextField!
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var linkBlueTextField: UITextField!
    @IBOutlet weak var fullnameTextField: UITextField!
    @IBOutlet weak var teamPicker: UIPickerView!
    @IBOutlet weak var namePicker: UIPickerView!
    
    // MARK: - Initialization---------------------------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        linkBlueTextField.isHidden = true
        fullnameTextField.isHidden = true
        teamPicker.isHidden = true
        namePicker.isHidden = true
        createTeamPicker()
        createTeamPicker2()
        //createToolBar()
        
        setupFirebase()
        checkStoredUUID()
    }
    
    // MARK: - custom UIPicker for master teams---------------------------------
    func createTeamPicker(){
        let teamPicker = UIPickerView()
        teamPicker.delegate = self
        
        teamTextField.inputView = teamPicker
    }
    
    // MARK: - custom UIPicker for master teams
    func createTeamPicker2(){
        let namePicker = UIPickerView()
        namePicker.delegate = self
        
        fullnameTextField.inputView = namePicker
    }
    // MARK: - custom toolbar for UIpicker--------------------------------------
    /*func createToolBar() {
        let toolBar = UIToolbar()
        toolBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .plain, target: self, action: #selector(CheckinViewController.dismissKeyboard(_:)))
        
        toolBar.setItems([doneButton], animated: false)
        toolBar.isUserInteractionEnabled = true
        
        teamTextField.inputAccessoryView = toolBar
    }
    
    func dismissKeyboard(_sender: UIBarButtonItem) {
     
     //check to see if the member name selected is in the team
     //check to see if other is selcted
     //if other is selcted display other text fields
     
        view.endEditing(true)
    }*/
    
    func sortMasterRoster() {
        dictROSTERKeys.sort(by: {$0 < $1})
    }
    func sortMasterTeams() {
        dictTEAMKeys.sort(by: {$0 < $1})
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
    func UpdateFirebase(){
        
    }
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
    
    // MARK: - Comfirm Checkin Button
    
    @IBAction func confirmCheckIn(_ sender: Any) {
        let teamField = String(teamTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        let nameField = String(nameTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) ?? "")
        let teamFlag  = teamField.isEmpty
        let nameFlag = nameField.isEmpty
        
        print("team: \(teamField) isEmpty: \(teamField.isEmpty)")
        print("name: \(nameField) isEmpty: \(nameField.isEmpty)")
        if(!teamFlag && !nameFlag){
            print("both are not empyt")
            print("linkBlueTextField.isHidden: \(linkBlueTextField.isHidden)")
            print("fullnameTextField.isHidden: \(fullnameTextField.isHidden)")
            //send things to the data base
            AddToFirebase()

        }
        else{
            print("something is empty")
            print("linkBlueTextField.isHidden: \(linkBlueTextField.isHidden)")
            print("fullnameTextField.isHidden: \(fullnameTextField.isHidden)")
            AddToFirebase()

        }
    }
}

// MARK: -Date picker for master roster and master teams
extension CheckinViewController: UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        let dictKeys = [String](masterTeamDICT.keys)
        let dictValues = [Int](masterTeamDICT.values)
        let dictKeysMember = [String](masterRosterDICT.keys)
        
        if(false){
            return dictKeys.count

        }else{
            return dictKeysMember.count

        }

    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let dictKeys = [String](masterTeamDICT.keys)
        let dictValues = [Int](masterTeamDICT.values)
        var dictKeysMember = [String](masterRosterDICT.keys)
        dictKeysMember.sort(by: {$0 < $1})
        if(false){
            return dictKeys[row]
        }
        else{
            return dictKeysMember[row]
        }
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        let dictKeys = [String](masterTeamDICT.keys)
        let dictValues = [Int](masterTeamDICT.values)
        let dictKeysMember = [String](masterRosterDICT.keys)
        if(false){
            selectedTeam = dictKeys[row]
            teamTextField.text = selectedTeam
        }
        else{
            selectedName = dictKeysMember[row]
            nameTextField.text = selectedName
        }
    }
}
