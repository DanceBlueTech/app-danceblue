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
protocol CurrentEventDelegate: class {
    func updateCoords(lat: String, long: String)
}
class EventDescriptionCell: UITableViewCell {
    
    static let identifier = "EventDescriptionCell"
    private var event: Event?
    weak var delegate: EventDescriptionDelegate?
    var currentEventDelegate: CurrentEventDelegate?
    //var delegate2: EventDescriptionCellDelegate?  //might not need
    //let geoCoder = CLGeocoder()
    
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
    
    #warning("FIX ME!")
    //checks to see if event is available for GeoFence checking in
    func displayCheckInButton(){
        
        var currentDate = Date()
        // 1) Create a DateFormatter() object.
        // 2) Set the current timezone to .current, or America/Chicago.
        // 3) Set the format of the altered date.
        // 4) Set the current date, altered by timezone.
        let format = DateFormatter()
        format.timeZone = .current
        format.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZ"
        let currentDateString = format.string(from: currentDate)
        
        let eventStartTime = event?.timestamp
        let eventEndTime = event?.endTime

        print("Today is: \(currentDate)")
        print("This is the Event's START Time : \(eventStartTime)")
        print("This is the Event's END Time : \(eventEndTime)")
    
        //TODO: if today is between current event start and stop time display 'checkin' button otherwise hide this feature
        //if((eventStartTime <= currentDateString) && (currentDateString <= eventEndTime))
        if(true){
            checkInButton.isHidden = false
        }
        else{
            checkInButton.isHidden = true
        }
    }
    
    #warning("FIX ME")
    // MARK: - Check in for GeoFences
    @IBAction func geoFenceCheckin(_ sender: Any) {
        print("Checking IN!!")      //debugging

        var latitude = ""
        var longitude = ""
        
        //call function to convert address to coordinates and store in variables
        //FIX this return variables
        let address = event!.address ?? ""
        LocationConverter.AddressToCoordinates.getCoords(Address: address)
        
        //use function to change data type from aboce to  to CLLocation2D--> func CLLocationCoordinate2DMake(CLLocationDegrees, CLLocationDegrees) -> CLLocationCoordinate2D
        //Formats a latitude and longitude value into a coordinate data structure format. then returns it
        
        //call functio to check if coordinates are valid and not broken and set to a bool then advance to check in screen
        if(areCoordsValid()){
            print("Validation was True!")       //debugging
            //TODO: send event address to Checkin View Controller
            convertToCoords()
            currentEventDelegate?.updateCoords(lat: "-0.213", long: "0.12123")
        }
        else{
            print("Event is not active at this moment")
            //Display an alert saying something went wrong and dont allow to check in
        }
    }
    #warning("FIX ME")
    func convertToCoords(){
        let geoCoder = CLGeocoder()
        let address = event!.address ?? ""

        geoCoder.geocodeAddressString(address) { (placemarks, error) in
        //geoCoder.geocodeAddressString(Address, completionHandler: @escaping){ (placemarks, error) in
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
    }
    #warning("FIX ME")
    func areCoordsValid() -> Bool {
        //TODO: validate coordinates
        let title = event?.title ?? ""
        let address = event!.address ?? ""
        let time = event!.time ?? ""
        #warning("reformat dates GMT i believe need to be +2 hours")
        let endtime = event!.endTime        //this is the end time of the event
        let timeStamp = event!.timestamp    //this is the start time of the event
        print("Event.Title: \(title)")
        print("Event.Address: \(address)")
        print("Event.Time \(time)")
        print("Event.Endtime: \(String(describing: endtime))")
        print("Event.Timestamp \(String(describing: timeStamp))")
        
        //if coords are valid
        //make sure to use---> func CLLocationCoordinate2DIsValid(CLLocationCoordinate2D) -> Bool
        //This function returns a Boolean value indicating whether the specified coordinate is valid.
        if(true) { return true }
        else { return false }
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
