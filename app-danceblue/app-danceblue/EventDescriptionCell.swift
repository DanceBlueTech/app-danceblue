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
/*
protocol EventDescriptionCellDelegate {
  func CheckInGeoFence(_ controller: EventDescriptionCell, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: Geotification.EventType)
}*/
protocol EventCoordinatesDelegate {
    func updateCoords(coordinates: CLLocationCoordinate2D)
}
class EventDescriptionCell: UITableViewCell {
    
    static let identifier = "EventDescriptionCell"
    private var event: Event?
    weak var delegate: EventDescriptionDelegate?
    var eventCoordinatesDelegate: EventCoordinatesDelegate?
    //var delegate2: EventDescriptionCellDelegate?  //might not need
    //let geoCoder = CLGeocoder()
    
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var underlineView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var checkInButton: UIButton!
    

    // MARK: - Initialization---------------------------------------------------
    override func awakeFromNib() {
        self.selectionStyle = .none
        underlineView.backgroundColor = Theme.Color.main
        descriptionTextView.font = Theme.Font.body
        titleLabel.font = Theme.Font.header
        titleLabel.text = "DESCRIPTION"
        setupTextView()
        //displayCheckInButton()
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
        displayCheckInButton()
    }
    
    // MARK: - Layout-----------------------------------------------------------
    override func sizeThatFits(_ size: CGSize) -> CGSize {
        var adjustedHeight = 8.0 + titleLabel.frame.height + 2.0 +  underlineView.frame.height + 16.0
        adjustedHeight += descriptionTextView.sizeThatFits(CGSize(width: size.width - 40, height: size.height)).height + 16.0
        return CGSize(width: bounds.width, height: adjustedHeight)
    }
    
    //checks to see if event is available for GeoFence checking in
    func displayCheckInButton(){
        
        // 1) Create a DateFormatter() object.
        // 2) Set the current timezone to .current, or America/Chicago.
        // 3) Set the format of the altered date.
        // 4) Set the current date, altered by timezone.
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"

        let currentDate = Date()
        let eventStartTime = event?.timestamp ?? Date.distantPast
        let eventEndTime = event?.endTime ?? Date.distantPast
        
        let currentDateString = format.string(from: currentDate)
        let eventStartString = format.string(from: eventStartTime)
        let eventEndString = format.string(from: eventEndTime)
        
        //  debugging!
        print("Today is: \(currentDate)")
        print("Today is String: \(currentDateString)")
        print("Event's START Time : \(eventStartTime)")
        print("Event's START Time String: \(eventStartString)")
        print("Event's END Time : \(eventEndTime)")
        print("Event's END Time String: \(eventEndString)")
        
        #warning("UNCOMMENT THIS IF STATEMENT BELOW, TEST AND PUSH FOR LIVE PRODUCTION!!")
        //if today is between current start and stop time display 'checkin' button
        //if((eventStartString <= currentDateString) && (currentDateString <= eventEndString)){
        if(true){
            checkInButton.isHidden = false
        }
        else{
            checkInButton.isHidden = true
        }
    }
    
    #warning("FIX ME")
    // MARK: - Check in for GeoFences-------------------------------------------
    @IBAction func geoFenceCheckin(_ sender: Any) {
        
        let eventAddress = event?.address ?? ""
        let geoCoder = CLGeocoder()
        
        //debugging
        print("Checking IN!!")
        let title = event?.title ?? ""
        let address = event!.address ?? ""
        let time = event!.time ?? ""
        print("Event.Title: \(title)")
        print("Event.Address: \(address)")
        print("Event.Time \(time)")
        
        //call function to convert address to coordinates and store in variables
        //This is an ssync call needs to be fixed!!!
        //FIX this return variables in the LocationCoverter file
        //LocationConverter.AddressToCoordinates.getCoords(Address: eventAddress)
        
        geoCoder.geocodeAddressString(eventAddress) { (placemarks, error) in guard
            let placemarks = placemarks,
            let location = placemarks.first?.location
            else {
                // handle no location found
                print("not a location! Returning")
                return
            }
            print("placemarkers: \(placemarks) istype: \(type(of: placemarks))")    //debugging
            print("location \(location) istype: \(type(of: location))")             //debugging
            let coords = location.coordinate
            let isvalid = CLLocationCoordinate2DIsValid(coords)
            print("coords: \(coords) istype: \(type(of: coords)) isvalid: \(isvalid)")  //debugging
            
            // Use your location
            #warning("move everything below out of this function since it is async...need to implement a completion handler")
            if(isvalid){
                print("Coordinates are valid")       //debugging
                //TODO: KYE!!!!!
                //TODO: send event address to Checkin View Controller
                //TODO: i havent figured out how to pass data to the checkinViewController
                print("eventCoordinatesDelegate: \(self.eventCoordinatesDelegate)")
                //might need to make the button be an action of showDetailViewController(_:sender:) instead of show
                self.eventCoordinatesDelegate?.updateCoords(coordinates: coords)
            }
            else{
                print("Coordinates are NOT valid")
                //Display an alert saying something went wrong and dont allow to check in
            }
        }
    }
}

// MARK: - UITextViewDelegate---------------------------------------------------
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
