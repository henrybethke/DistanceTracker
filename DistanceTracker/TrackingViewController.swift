//
//  TrackingViewController.swift
//  DistanceTracker
//
//  Created by Henry Bethke on 4/13/18.
//  Copyright © 2018 Henry Bethke. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class TrackingViewController: UIViewController, CLLocationManagerDelegate {
    
    var distance = 0 {
        didSet {
            self.distanceLabel.text = "\(distance) yards"
        }
    }
    var state: TrackingState = .Idle
    
    var locationManager = CLLocationManager()
    
    var startLocation: CLLocation?

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var trackButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.startUpdatingLocation()
    }

    @IBAction func trackButtonTapped(_ sender: Any) {
        updateTrackButton()
        self.startLocation = locationManager.location
    }
    
    func updateTrackButton() {
        if state == .Idle {
            state = .Tracking
            trackButton.setTitle("Stop", for: .normal)
        } else {
            state = .Idle
            trackButton.setTitle("Track", for: .normal)
        }
    }
    
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let currentLocation = locations.last
       
        if state == .Tracking {
            let meters = self.startLocation?.distance(from: currentLocation!)
            self.distance = Int(meters! * Constants.yardsPerMeter)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("did fail with error: \(error)")
    }
}
