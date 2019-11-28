//
//  EventDetailsViewController.swift
//  app-danceblue
//
//  Created by Blake Swaidner on 7/23/17.
//  Copyright © 2017 DanceBlue. All rights reserved.
//

import EventKit
import FirebaseAnalytics
import SafariServices
import UIKit

protocol EventDetailsViewControllerDelegate: class {
    func heartButton(didChangeValueFor event: Event, value: Int)
}

class EventDetailsViewController: UITableViewController {
    
    var event: Event?
    let eventStore = EKEventStore()
    var cellHeights: [CGFloat] = [CGFloat].init(repeating: 0, count: 5)
    
    weak var delegate: EventDetailsViewControllerDelegate?
    
    // MARK: - Initialization
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
    }
    
    func setupTableView() {
        tableView.allowsSelection = true
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if navigationController?.isNavigationBarHidden ?? false {
            navigationController?.setNavigationBarHidden(false, animated: false)
        }
        Analytics.logEvent("Event_Did_Appear", parameters: ["Title" : event?.title ?? ""])
        setUpNavigation(controller: navigationController, hidesBar: false)
        self.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addEventToCalendar(addAnyways:)))
        
    }
    
    // MARK: - TableView Data Source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if event?.flyer != nil && event?.map != nil { return 5 }
        else if event?.flyer != nil || event?.map != nil { return 4 }
        return 3
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return cellHeights[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let event = event else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            if let headerCell = tableView.dequeueReusableCell(withIdentifier: EventHeaderCell.identifier, for: indexPath) as? EventHeaderCell {
                headerCell.configureCell(with: event)
                //headerCell.delegate = self    // used for "going"
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = headerCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                }
                
                return headerCell
            }
        case 1:
            if let detailsCell = tableView.dequeueReusableCell(withIdentifier: EventDetailsTableViewCell.identifier, for: indexPath) as? EventDetailsTableViewCell {
                detailsCell.configureCell(with: event)
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = detailsCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                }
                
                return detailsCell
            }
        case 2:
            if let descriptionCell = tableView.dequeueReusableCell(withIdentifier: EventDescriptionCell.identifier, for: indexPath) as? EventDescriptionCell {
                descriptionCell.configureCell(with: event)
                descriptionCell.delegate = self
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = descriptionCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                }
                
                return descriptionCell
            }
        case 3:
            if event.flyer != nil, let flyerCell = tableView.dequeueReusableCell(withIdentifier: EventFlyerCell.identifier, for: indexPath) as? EventFlyerCell {
                flyerCell.configureCell(with: event)
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = flyerCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                }
                return flyerCell
            } else {
                if let mapCell = tableView.dequeueReusableCell(withIdentifier: EventMapCell.identifier, for: indexPath) as? EventMapCell {
                    mapCell.configureCell(with: event)
                    if cellHeights[indexPath.row] == 0 {
                        cellHeights[indexPath.row] = mapCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                    }
                    
                    return mapCell
                }
            }
        case 4:
            if let mapCell = tableView.dequeueReusableCell(withIdentifier: EventMapCell.identifier, for: indexPath) as? EventMapCell {
                mapCell.configureCell(with: event)
                if cellHeights[indexPath.row] == 0 {
                    cellHeights[indexPath.row] = mapCell.sizeThatFits(CGSize(width: view.bounds.width, height: .greatestFiniteMagnitude)).height
                }
                
                return mapCell
            }
        default:
            return UITableViewCell()
        }
        return UITableViewCell()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "FlyerSegue", let ivc = segue.destination as? ImageViewController {
            ivc.setupViews(with: event?.flyer)
        }
    }
    
    // MARK: - Calendar
    
    @objc func addEventToCalendar(addAnyways: Bool = false) {
        guard let event = event else { return }
        eventStore.requestAccess(to: .event) { (granted, error) in
            
            if (granted) && (error == nil) {
                let calendarEvent = EKEvent(eventStore: self.eventStore)
                
                guard let startDate = event.timestamp else {
                    self.showFailedAlert()
                    return
                }
                guard let endDate = event.endTime else {
                    self.showFailedAlert()
                    return
                }
                
                calendarEvent.title = event.title
                calendarEvent.startDate = startDate
                calendarEvent.endDate = endDate
                calendarEvent.notes = event.description
                calendarEvent.location = event.address
                calendarEvent.calendar = self.eventStore.defaultCalendarForNewEvents
                
                do {
                    
                    let CALENDAR_DEFAULTS_KEY = "\(String(describing: calendarEvent.title))\(startDate.description)_ADDED_TO_CALENDAR"
                    
                    if let _: Bool = UserDefaults.standard.bool(forKey: CALENDAR_DEFAULTS_KEY), !addAnyways {
                        self.showDuplicateAlert()
                    } else {
                        print("Here")
                        UserDefaults.standard.set(true, forKey: CALENDAR_DEFAULTS_KEY)
                        try self.eventStore.save(calendarEvent, span: .thisEvent)
                        self.showSuccessAlert()
                    }
                    
                } catch let error as NSError {
                    self.showFailedAlert()
                    log.debug("Failed to save event with error : \(error)")
                }
            } else if !granted {
                self.showSettingsAlert()
                
            } else {
                self.showFailedAlert()
                log.debug("Failed to save event with error : \(String(describing: error)) or access not granted")
            }
        }
    }
    
    // MARK: - Alerts
    
    func showSettingsAlert() {
        let alertController = UIAlertController(title: "DanceBlue needs access to your Calendar", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Go To Settings", style: .default, handler: { alert in
            if let url = URL(string: "app-settings:root=Privacy&path=CALENDARS") {
                UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
            }
            
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showFailedAlert() {
        let alertController = UIAlertController(title: "Something went wrong.", message: "We were unable to add this event to your calendar.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showDuplicateAlert() {
        let alertController = UIAlertController(title: "Duplicate Event", message: "This event has already been added to your calendar.", preferredStyle: .alert)
        alertController.addAction(UIAlertAction(title: "Add Anyways", style: .default, handler: { (alert) in
            self.addEventToCalendar(addAnyways: true)
        }))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
    func showSuccessAlert() {
        let alertController = UIAlertController(title: "Event Added", message: nil, preferredStyle: .alert)
        
        alertController.addAction(UIAlertAction(title: "Go To Calendar", style: .default, handler: { alert in
                if let url = URL(string: "calshow://") {
                    UIApplication.shared.open(url, options: convertToUIApplicationOpenExternalURLOptionsKeyDictionary([:]), completionHandler: nil)
                }
                
            }))
        alertController.addAction(UIAlertAction(title: "Close", style: .cancel, handler: nil))
        present(alertController, animated: true, completion: nil)
    }
    
}

// MARK: - EventDescriptionDelegate

extension EventDetailsViewController: EventDescriptionDelegate {
    
    func textView(didPresentSafariViewController url: URL) {
        let svc = SFSafariViewController(url: url)
        svc.preferredControlTintColor = Theme.Color.main
        self.present(svc, animated: true, completion: nil)
    }
    
}

// Helper function inserted by Swift 4.2 migrator.
fileprivate func convertToUIApplicationOpenExternalURLOptionsKeyDictionary(_ input: [String: Any]) -> [UIApplication.OpenExternalURLOptionsKey: Any] {
	return Dictionary(uniqueKeysWithValues: input.map { key, value in (UIApplication.OpenExternalURLOptionsKey(rawValue: key), value)})
}
