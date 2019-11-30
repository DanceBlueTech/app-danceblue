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
    //var geotifications: [Geotification] = []

    //let locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //locationManager.delegate = self as? CLLocationManagerDelegate
        //locationManager.requestAlwaysAuthorization()
    }
    
    // MARK: - Set up geofence region
    /*func region(with geotification: Geotification) -> CLCircularRegion {
        // 1
        let region = CLCircularRegion(center: geotification.coordinate,
        radius: geotification.radius,
        identifier: geotification.identifier)
        // 2
        region.notifyOnEntry = (geotification.eventType == .onEntry)
        region.notifyOnExit = !region.notifyOnEntry
        return region
    }*/
    
    // MARK: - Start monitoring the Geofence regions
    /*func startMonitoring(geotification: Geotification) {
        // 1
        if !CLLocationManager.isMonitoringAvailable(for: CLCircularRegion.self) {
            showAlert(withTitle: kErrorTitle1, message: kErrorMessage1)
            return
        }
        // 2
        if CLLocationManager.authorizationStatus() != .authorizedAlways {
            showAlert(withTitle:kErrorTitle2, message: kErrorMessage2)
        }
        // 3
        let fenceRegion = region(with: geotification)
        // 4
        locationManager.startMonitoring(for: fenceRegion)
        
        //TODO: if in region after checking in, call stop monitoring
    }
    
    // MARK: - Stop monitoring the Geofence regions
    func stopMonitoring(geotification: Geotification) {
        for region in locationManager.monitoredRegions {
            guard let circularRegion = region as? CLCircularRegion,
                circularRegion.identifier == geotification.identifier else { continue }
            locationManager.stopMonitoring(for: circularRegion)
        }
    }*/
}
// MARK: - Location Manager Delegate
extension GeotificationsViewController: CLLocationManagerDelegate {
  
  /*func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    mapView.showsUserLocation = status == .authorizedAlways
  }*/
  /*
  func locationManager(_ manager: CLLocationManager, monitoringDidFailFor region: CLRegion?, withError error: Error) {
    print(kErrorMessage3 + region!.identifier)
  }
  
  func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
    print(kErrorMessage4 + "\(error)")
  }*/
  
}
/*
// MARK: AddGeotificationViewControllerDelegate
extension GeotificationsViewController: EventDescriptionCellDelegate {
    // MARK: - checking into the geo fence
    func CheckInGeoFence(_ controller: EventDescriptionCell, didAddCoordinate coordinate: CLLocationCoordinate2D, radius: Double, identifier: String, note: String, eventType: Geotification.EventType) {
      //controller.dismiss(animated: true, completion: nil)
      let clampedRadius = min(radius, locationManager.maximumRegionMonitoringDistance)
      let geotification = Geotification(coordinate: coordinate, radius: clampedRadius, eventType: eventType)
      //add(geotification)
      startMonitoring(geotification: geotification)
      //saveAllGeotifications()
    }
}*/

extension GeotificationsViewController: GeoFenceDelegate2 {
    // MARK: - checking into the geo fence
    func CheckInGeoFence(_ controller: CheckinViewController, x: String) {
      print(x)
    }
}

// MARK: -
extension GeotificationsViewController: GeoFenceDelegate {
    func checkInGeoFence() {
        print("made it to GeotificationsViewController!")
    }
}
