//
//  ViewController.swift
//  ChewChew
//
//  Created by Clayton To on 9/17/15.
//  Copyright (c) 2015 ChewChew. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire

class ViewController: UIViewController {
    
    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
    var trainStation: String = ""
    var distanceRadius: Double = 1.5;
    
    var locationsList: [Location] = [Location]()
    
    @IBOutlet weak var button: UIButton!
    
    // Update the slider label
    @IBAction func sliderValueChanged(sender: UISlider) {
        distanceRadius = Double(sender.value)
        distanceRadius = round(10*distanceRadius)/10    // show 1 digit after decimal
        
        label.text = "\(distanceRadius) miles"          // update label
    }
    
    // Save the train station and distance radius when user hits search button
    @IBAction func searchPressed(sender: UIButton) {
        trainStation = search.text!
        
        // convert miles to meters
        distanceRadius = distanceRadius * 1609.34
    }
    
    // GETTER FUNCTIONS //
    
    // Get the user's train station
    func getStation() -> String {
        return trainStation
    }
    
    // Get the user's distance radius
    func getDistance() -> Double {
        return distanceRadius
    }
    
    // OVERRIDE FUNCTIONS //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // Pass data from home page to list page
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        if (segue.identifier == "populateTableWithLocations") {
            // Get user input
            trainStation = search.text!
            distanceRadius = distanceRadius * 1609.34
            
            // Get the latitude and longitude from user input
            var trainCoordinates: [Double] = [Double]()
            
            var stationFinder: TrainStationFinder = TrainStationFinder(station: trainStation, coordinates: trainCoordinates)
            trainCoordinates = stationFinder.coordinates
            
            let trainLatitude = trainCoordinates[0]
            let trainLongitude = trainCoordinates[1]
            
            // Retrieve data based on user input
            var locationFinder : LocationFinder = LocationFinder(latitude: trainLatitude, longitude: trainLongitude, distance: distanceRadius, locations: locationsList)
            locationsList = locationFinder.locations
            
            // Pass data from home page to navigation controller
            // since list page is embedded into navigation controller
            let firstPage = segue.destinationViewController as! UINavigationController
            let secondPage = firstPage.topViewController as! LocationsViewController;
            secondPage.toPass = locationsList
        }
    }

}

