//
//  GeoFencingViewController.swift
//  app-danceblue
//
//  Created by David Mercado on 10/7/19.
//  Copyright © 2019 DanceBlue. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import CoreLocation

class GeotificationsViewController: UIViewController {

    // MARK: - Initialization
    var geotifications: [Geotification] = []

    let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self as? CLLocationManagerDelegate
        locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Set up geofence region
    func region(with geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate,
        radius: geotification.radius,
        identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }
    
    // MARK: - Start monitoring the Geofence regions
    func startMonitoring(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
        showAlert(withTitle: kError1, message: kErrorMessage1)
        return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
        let message = """
          Your geotification is saved but will only be activated once you grant
          Geotify permission to access the device location.
          """
        showAlert(withTitle:"Warning", message: message)
        }
        // 3
        let fenceRegion = region(with: geotification)
        // 4
        locationManager.startMonitoring(for: fenceRegion)
    }
}
