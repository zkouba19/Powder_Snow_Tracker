//
//  RunResultTableViewController.swift
//  Powder_Snow_Tracker
//
//  Created by Zachary Kouba on 1/24/17.
//  Copyright © 2017 Zachary Kouba. All rights reserved.
//

import Foundation
import UIKit
import MapKit


class RunResultViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate, CLLocationManagerDelegate {
    @IBOutlet weak var mapView: MKMapView!
    var delegate: RunResultDelegate?
    var distance: Double?
    var absoluteStartLocation: CLLocation?
    var absoluteEndLocation: CLLocation?
    var avgSpeed: Double?
    var jumps: Int?
    var maxSpeed: Double?
    var altitude: Double?
    var biffs: Int?
    var time: Date?
    var userID: Int?
    var titles = ["Distance", "Time", "Altitude Drop", "Jump Count","Biff Count", "Top Speed", "Average Speed"]
    var data = [String]()

    
    
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return titles.count
    }
    
    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runReportCustomCell", for: indexPath) as! runReportCustomCell
        cell.dataTitle?.text = titles[indexPath.row]
        cell.dataInfo?.text = data[indexPath.row]
        return cell
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        data = [String(describing: distance), String(describing: time), String(describing: altitude), String(describing: jumps), String(describing: biffs), String(describing: maxSpeed), String(describing: avgSpeed)]
        mapView.delegate = self
        print(absoluteStartLocation!.coordinate)
        print(absoluteEndLocation!)
        let sourceLocation = absoluteStartLocation!.coordinate
        let destinationLocation = absoluteEndLocation!.coordinate
        
        
        
        // Map info 3.
        let sourcePlacemark = MKPlacemark(coordinate: sourceLocation, addressDictionary: nil)
        let destinationPlacemark = MKPlacemark(coordinate: destinationLocation, addressDictionary: nil)
        
        // 4.
        let sourceMapItem = MKMapItem(placemark: sourcePlacemark)
        let destinationMapItem = MKMapItem(placemark: destinationPlacemark)
        
        // 5.
        let sourceAnnotation = MKPointAnnotation()
        sourceAnnotation.title = "Times Square"
        
        if let location = sourcePlacemark.location {
            sourceAnnotation.coordinate = location.coordinate
        }
        
        
        let destinationAnnotation = MKPointAnnotation()
        destinationAnnotation.title = "Empire State Building"
        
        if let location = destinationPlacemark.location {
            destinationAnnotation.coordinate = location.coordinate
        }
        
        // 6.
        self.mapView.showAnnotations([sourceAnnotation,destinationAnnotation], animated: true )
        
        // 7.
        let directionRequest = MKDirectionsRequest()
        directionRequest.source = sourceMapItem
        directionRequest.destination = destinationMapItem
        directionRequest.transportType = .any
        
        // Calculate the direction
        let directions = MKDirections(request: directionRequest)
        
        // 8.
        directions.calculate {
            (response, error) -> Void in
            
            guard let response = response else {
                if let error = error {
                    print("Error: \(error)")
                }
                
                return
            }
            
            let route = response.routes[0]
            self.mapView.add((route.polyline), level: MKOverlayLevel.aboveRoads)
            
            let rect = route.polyline.boundingMapRect
            self.mapView.setRegion(MKCoordinateRegionForMapRect(rect), animated: true)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.saveRun(time: time!, distance: distance!, avgspeed: avgSpeed!, maxSpeed: maxSpeed!, altitude: altitude!, absoluteStartLocation: absoluteStartLocation!, absoluteEndLocation: absoluteEndLocation!, jumps: jumps!, biffs: biffs!, userID: userID!)
    }
    @IBAction func trashButtonPressed(_ sender: UIBarButtonItem) {
        delegate?.cancelButtonPressed(by: self)
    }
 
    
    
    
    
    
    
    
}
