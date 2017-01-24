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


class RunResultViewController: UIViewController, MKMapViewDelegate, UITableViewDelegate {
    
    var titles = ["Distance", "Time", "Altitude Drop", "Jump Count","Biff Count", "Top Speed", "Average Speed"]
    var data = [String]()
    
    
    
    @IBOutlet weak var tableView: UITableView!

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 7
    }
    
    private func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "runReportCustomCell", for: indexPath) as! runReportCustomCell
        cell.dataTitle?.text = titles[indexPath.row]
        cell.dataInfo?.text = data[indexPath.row]
        return cell
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveButtonPressed(_ sender: UIBarButtonItem) {
    }
    @IBAction func trashButtonPressed(_ sender: UIBarButtonItem) {
    }
 
    
    @IBOutlet weak var mapView: MKMapView!
 
    
    
    
    
}
