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

class TrackingViewController: UIViewController, CLLocationManagerDelegate, UIAlertViewDelegate {
    
    var distance = 0 {
        didSet {
            self.distanceLabel.text = "\(distance) yards"
        }
    }
    var state: TrackingState = .Idle
    var locationManager = CLLocationManager()
    var startLocation: CLLocation?
    
    //TODO persist shots
    var shots: [Shot] = []

    @IBOutlet weak var distanceLabel: UILabel!
    @IBOutlet weak var trackButton: UIButton!
    
    @IBAction func trackButtonTapped(_ sender: Any) {
        if state == .Tracking {
            showAlert()
        }
        updateTrackButton()
        self.startLocation = locationManager.location
    }
    
    @IBAction func myShotsButtonTapped(_ sender: Any) {
        performSegue(withIdentifier: Constants.myShotsSegue, sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager.delegate = self
        locationManager.requestWhenInUseAuthorization()
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.distanceFilter = kCLDistanceFilterNone
        
        locationManager.startUpdatingLocation()
    }
    
    func updateTrackButton() {
        if state == .Idle {
            state = .Tracking
            trackButton.setTitle(Constants.stopLabelText, for: .normal)
        } else {
            state = .Idle
            trackButton.setTitle(Constants.trackLabelText, for: .normal)
        }
    }
    
    // MARK: location manager delegate methods
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
    
    func showAlert() {
        let alertController = UIAlertController(title: Constants.saveShotText, message: "", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: Constants.saveActionText, style: .default, handler: {_ in
            self.saveShot()
        }))
        alertController.addAction(UIAlertAction(title: Constants.cancelActionText, style: .cancel, handler: {_ in
            self.resetTracking()
        }))
        self.present(alertController, animated: true, completion: nil)
    }
    
    func saveShot() {
        let shot = Shot(distance: self.distance, location: self.locationManager.location, date: Date())
        self.shots.append(shot)
        sortShots(self.shots)
        
        resetTracking()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Constants.myShotsSegue {
            let destinationController = segue.destination as? MyShotsTableViewController
            destinationController?.shots = self.shots
        }
    }
    
    func resetTracking() {
        self.distance = 0
        self.state = .Idle
    }
    
    func sortShots(_ shots: [Shot]) {
        self.shots = shots.sorted(by: {$0.distance > $1.distance} )
    }
}
