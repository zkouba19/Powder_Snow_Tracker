//
//  TrackingViewController.swift
//  Powder_Snow_Tracker
//
//  Created by Zachary Kouba on 1/24/17.
//  Copyright © 2017 Zachary Kouba. All rights reserved.
//

import UIKit
import CoreMotion
import CoreFoundation
import CoreLocation


class TrackingViewController: UIViewController, CLLocationManagerDelegate, RunResultDelegate  {
//    all variables
    // labels
    @IBOutlet weak var trackingButtonPressed: UIButton!
    
    // stats
    var count = 0
    var biffCount = 0
    var jumpCount = 0
    var altitudeChange: Double = 0.0
    var startTime: Date?
    var avgSpeedDividedBy = 0
    var time: Double = 0
    var distance: Double = 0
    var maxSpeed: Double = 0
    var currentSpeed: CLLocationSpeed?
    var userID: Int?

    //    managers
    var altimeterManager: CMAltimeter?
    var rotationRate: CMMotionManager?
    var absoluteStartLocation: CLLocation?
    var absoluteEndLocation: CLLocation?
    var locationManager: CLLocationManager?
    var speed: CLLocationSpeed = 0.0
    var startLocation: CLLocation?
    var currentLocation: CLLocation?
    weak var timer: Timer? = nil
 
//  end of variables
// functions
    func endTimer() {
        self.count = 0
        self.timer?.invalidate()
        self.timer = nil
    }
    
    
    override func motionBegan(_ motion: UIEventSubtype, with event: UIEvent?) {
        biffCount += 1
    }
    
    // for delegates
    func cancelButtonPressed(by controller: RunResultViewController){
        dismiss(animated: true, completion: nil)
        time = 0.00
        speed = 0
        maxSpeed = 0
        distance = 0
        biffCount = 0
        jumpCount = 0
        altitudeChange = 0.0
        avgSpeedDividedBy = 0
    }
    
    func saveRun(time: Date, distance: Double, avgspeed: Double, maxSpeed: Double, altitude: Double, absoluteStartLocation: CLLocation, absoluteEndLocation: CLLocation, jumps: Int, biffs: Int, userID: Int){
        var HTTPString = "altitudeDrop=\(altitude)&distance=\(distance)&time=\(time)&topSpeed=\(maxSpeed)&avgSpeed=\(avgspeed)&biffsCount=\(biffs)&jumpsCount=\(jumps)&user=\(userID)"
        git 
        
        
        
        
        
        // dismiss(animated: true, completion: nil)
    }
    
    // end of delegates
    
    
    
// end of functions
    
    override func viewDidLoad() {
        super.viewDidLoad()
        locationManager = CLLocationManager()
        if let allowLocation = locationManager {
            allowLocation.requestWhenInUseAuthorization()
        }
        trackingButtonPressed.setTitle("Start Tracking", for: .normal)
        trackingButtonPressed.backgroundColor = UIColor.green

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trackingButtonPressed(_ sender: UIButton) {
        
        
        count += 1
        // we are now tracking
        if count % 2 == 1 {
            trackingButtonPressed.setTitle("Stop Tracking", for: .normal)
            trackingButtonPressed.backgroundColor = UIColor.red
            
            if let location = locationManager {
                print("location manager created")
                location.requestWhenInUseAuthorization()
                location.delegate = self
                location.desiredAccuracy = kCLLocationAccuracyBestForNavigation
                location.distanceFilter = 1.0
                location.startUpdatingLocation()
                absoluteStartLocation = location.location!
                startLocation = location.location!
                print(location.location!)
                timer = Timer.scheduledTimer(withTimeInterval: 1.0, repeats: true) {
                    (_) in
                    location.startUpdatingLocation()
                    print("timer is working")
                    self.absoluteEndLocation = location.location!
                    self.avgSpeedDividedBy += 1
                    self.time = self.time + 0.01
                    if self.avgSpeedDividedBy > 1 {
                        self.distance += location.location!.distance(from: self.startLocation!)
                        self.startLocation = location.location!
                        
                        print("working")
                        self.currentSpeed = self.startLocation?.speed
                        if Int(self.currentSpeed!) >= 0 {
                            
                            self.speed += self.currentSpeed!
                            print("Speed: \(self.speed)")
                        }
                        else {
                            self.avgSpeedDividedBy -= 1
                            print("No Speed")
                        }
                    }
                    else {
                        print("Not Tracking")
                    }
                    if location.location!.speed > self.maxSpeed {
                        self.maxSpeed = location.location!.speed / 0.4470399999
                    }
                }
            }
            var jumpResults = [Double]()
            altimeterManager = CMAltimeter()
            if let altimetermanager = altimeterManager {
                if CMAltimeter.isRelativeAltitudeAvailable(){
                    let altimeterQ = OperationQueue()
                    altimetermanager.startRelativeAltitudeUpdates(to: altimeterQ) {
                        [weak self] (altimeterData: CMAltitudeData?, error: Error?) in
                        if let altimeterdata = altimeterData {
                            let altitude = altimeterdata.relativeAltitude
                            print("Altitidue: " + String(describing: altitude))
                            self?.altitudeChange = Double(altitude)
                            jumpResults.append(Double(altitude))
                        }
                        else {
                            print("Not enough" + String(jumpResults.count))
                        }
                        if jumpResults.count > 2 {
                            let finalMeasurementPoint = jumpResults[jumpResults.count - 1]
                            let secondMeasurementPoint = jumpResults[jumpResults.count - 2]
                            if finalMeasurementPoint - secondMeasurementPoint > 0.15 {
                                self!.jumpCount += 1
                            }
                        }
                    }
                }
                else {
                    print("No altimeter available")
                }
            }
            else {
                print("no location manager")
            }
        }
        // end of tracking
        // sending data to new scene
        else {
            count = 0
            endTimer()
            trackingButtonPressed.setTitle("Start Tracking", for: .normal)
            trackingButtonPressed.backgroundColor = UIColor.green
            altimeterManager!.stopRelativeAltitudeUpdates()
            print(altitudeChange)
            let conversionToFeet = (altitudeChange*3.280839895) * -1
            performSegue(withIdentifier: "runDetailsSegue", sender: self)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        let navigationController = segue.destination as! UINavigationController
        navigationController.navigationBar.barTintColor = UIColor.blue
        navigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        let RunResultViewController = navigationController.topViewController as! RunResultViewController
        RunResultViewController.delegate = self
        RunResultViewController.distance = distance
        RunResultViewController.absoluteStartLocation = absoluteStartLocation
        RunResultViewController.absoluteEndLocation = absoluteEndLocation
        RunResultViewController.avgSpeed = (self.speed / 0.4470399999)/Double(self.avgSpeedDividedBy)
        RunResultViewController.jumps = jumpCount
        RunResultViewController.maxSpeed = maxSpeed
        RunResultViewController.altitude = (altitudeChange*3.280839895) * -1
        RunResultViewController.biffs = biffCount
        RunResultViewController.userID = userID
    }
    
}





