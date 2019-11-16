//
//  EventDescriptionCell.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 9/21/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import UIKit
import MapKit

protocol EventDescriptionDelegate: class {
    func textView(didPresentSafariViewController url: URL)
}

//TODO: https://blog.usejournal.com/geofencing-in-ios-swift-for-noobs-29a1c6d15dcc
//might need to set up regions on events tab clicked or keep it with the button click of check in??

protocol EventDescriptionCellDelegate {
  func CheckInGeoFence(_ controller: EventDescriptionCell, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: Geotification.EventType)
}

class EventDescriptionCell: UITableViewCell {
    
    static let identifier = "EventDescriptionCell"
    private var event: Event?
    var masterRoster : [MasterRoster] = []
    var masterTeams : [MasterTeams] = []
    weak var delegate: EventDescriptionDelegate?
    var delegate2: EventDescriptionCellDelegate?
    let geoCoder = CLGeocoder()
    let today = Date.init() //--> change time zones
    //var eventStartTime = Date.init()
    //var eventEndTime = Date.init()

    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    

    // MARK: - Initialization
    
    override func awakeFromNib() {
        self.selectionStyle = .none
        underlineView.backgroundColor = Theme.Color.main
        descriptionTextView.font = Theme.Font.body
        titleLabel.font = Theme.Font.header
        titleLabel.text = "DESCRIPTION"
        setupTextView()
        displayCheckInButton()
    }

    func setupTextView() {
        descriptionTextView.delegate = self
        descriptionTextView.dataDetectorTypes = [.link]
        descriptionTextView.linkTextAttributes = convertToOptionalNSAttributedStringKeyDictionary([NSAttributedString.Key.foregroundColor.rawValue: Theme.Color.main])
        descriptionTextView.isSelectable = true
        descriptionTextView.isEditable = false
        descriptionTextView.tintColor = Theme.Color.main
        descriptionTextView.textContainerInset = .zero
        descriptionTextView.contentInset = .zero
        descriptionTextView.textContainer.lineFragmentPadding = 0.0
    }
    
    func configureCell(with event: Event) {
        self.event = event
        descriptionTextView.text = event.description ?? ""
    }
    
    // MARK: - Layout
    
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjustedHeight = 8.0 + titleLabel.frame.height + 2.0 +  underlineView.frame.height + 16.0
        adjustedHeight += descriptionTextView.sizeThatFits(CGSize(width: size.width - 40, height: size.height)).height + 16.0
        return CGSize(width: bounds.width, height: adjustedHeight)
    }
    
    func displayCheckInButton(){
        //var eventStartTime = event!.timestamp
        //var eventEndTime = event!.endTime
        print("Today is: \(today)")
        //print("This is the Event's START Time : \(eventStartTime)")
        //print("This is the Event's END Time : \(eventEndTime)")
        if(true){
            checkInButton.isHidden = false
        }
        else{
            checkInButton.isHidden = true
        }
    }
    
    // MARK: - Check in for GeoFences
    @IBAction func geoFenceCheckin(_ sender: Any) {
        print("Checking IN!!")
        //createTeamPicker()
        //createToolBar()
        
        
        checkDeviceUUID()
        
        let validationFlag = checkEventInfomation()
        if(validationFlag){
            print("Validation was True!")
            /*let coordinate = mapView.centerCoordinate
             let radius = Double(radiusTextField.text!) ?? 0
             let identifier = NSUUID().uuidString
             let note = noteTextField.text
             let eventType: Geotification.EventType = (eventTypeSegmentedControl.selectedSegmentIndex == 0) ? .onEntry : .onExit
             delegate2?.GeotificationViewController(self, didAddCoordinate: coordinate, radius: radius, identifier: identifier, note: note!, eventType: eventType)*/
        }
        else{
            print("Event is not active at this moment")
        }
    }
    func checkDeviceUUID(){
        print("MasterRoster: \(String(describing: self.masterRoster[0].printAll())) Count: \(masterRoster.count)")
        print("MasterTeams: \(String(describing: self.masterTeams[0].printAll())) Count: \(masterTeams.count)")
    }
    
    func checkEventInfomation() -> Bool {
        let title = event?.title ?? ""
        let addy = event!.address ?? ""
        let time = event!.time ?? ""
        #warning("reformat dates GMT i believe need to be +2 hours")
        let endtime = event!.endTime        //this is the end time of the event
        let timeStamp = event!.timestamp    //this is the start time of the event
        print("Event.Title: \(title)")
        print("Event.Address: \(addy)")
        print("Event.Time \(time)")
        print("Event.Endtime: \(String(describing: endtime))")
        print("Event.Timestamp \(String(describing: timeStamp))")
        
        //this is an async call...need a callback function
        geoCoder.geocodeAddressString(addy) { (placemarks, error) in
            guard
                let placemarks = placemarks,
                let location = placemarks.first?.location
                else {
                    // handle no location found
                    print("not a location! Returning")
                    return
            }
            print("placemarkers \(placemarks)")
            print("location \(location)")
            // Use your location
        }
        return true
    }
}

// MARK: - UITextViewDelegate

extension EventDescriptionCell: UITextViewDelegate {
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        
        if URL.absoluteString.contains("mailto:") {
            return true
        }
        
        delegate?.textView(didPresentSafariViewController: URL)
        return false
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToOptionalNSAttributedStringKeyDictionary(_ input: [String: Any]?) -> [NSAttributedString.Key: Any]? {
	guard let input = input else { return nil }
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (NSAttributedString.Key(rawValue: key), value)})
}
