//
//  RunResultsDelegate.swift
//  Powder_Snow_Tracker
//
//  Created by Zachary Kouba on 1/24/17.
//  Copyright © 2017 Zachary Kouba. All rights reserved.
//

import Foundation
import UIKit
import CoreLocation

protocol RunResultDelegate: class {
    func cancelButtonPressed(by controller: RunResultViewController)
    func saveRun(time: Date, distance: Double, avgspeed: Double, maxSpeed: Double, altitude: Double, absoluteStartLocation: CLLocation, absoluteEndLocation: CLLocation, jumps: Int, biffs: Int, userID: Int)
}



