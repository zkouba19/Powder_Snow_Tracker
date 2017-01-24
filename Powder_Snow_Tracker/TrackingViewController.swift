//
//  TrackingViewController.swift
//  Powder_Snow_Tracker
//
//  Created by Zachary Kouba on 1/24/17.
//  Copyright © 2017 Zachary Kouba. All rights reserved.
//

import Foundation
import UIKit

class TrackingViewController: UIViewController {
    
    @IBOutlet weak var trackingButtonPressed: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        trackingButtonPressed.setTitle("Start Tracking", for: .normal)
        trackingButtonPressed.backgroundColor = UIColor.green

    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func trackingButtonPressed(_ sender: UIButton) {
        trackingButtonPressed.setTitle("Stop Tracking", for: .normal)
        trackingButtonPressed.backgroundColor = UIColor.red
        
    }
    
}
