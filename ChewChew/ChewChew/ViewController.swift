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

class ViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
//    @IBOutlet weak var search: UISearchBar!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var placePicker: UIPickerView!
    
    var placePickerDataSource = ["Claremont", "Union Station"];
    
    var trainStation: String = ""

    var distanceRadius: Double = 1.5;
    
    var locationsList: [Location] = [Location]()
    var reviewList: [Review] = [Review]()
    
    @IBOutlet weak var button: UIButton!
    
    // Update the slider label
    @IBAction func sliderValueChanged(sender: UISlider) {
        distanceRadius = Double(sender.value)
        distanceRadius = round(10*distanceRadius)/10    // show 1 digit after decimal
        
        label.text = "\(distanceRadius) miles"          // update label
    }
    
    @IBAction func searchPressed(sender: UIButton) {
        
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
        
        self.placePicker.dataSource = self;
        self.placePicker.delegate = self;
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // DISABLED SEARCH BAR TO IMPLEMENT PLACE PICKER
    
//    // Dismiss the keyboard when user taps outside of search bar
//    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?){
//        view.endEditing(true)
//        super.touchesBegan(touches, withEvent: event)
//    }
    
    // UIPICKERVIEW DELEGATE METHODS //
    
    // Number of columns
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // Number of rows
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return placePickerDataSource.count;
    }
    
    // Data for a specific row and specific column
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String! {
        return placePickerDataSource[row]
    }
    
    // detecting selected row
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int)
    {
        trainStation = placePickerDataSource[row]
    }
    
    // SEGUE METHODS //
    
    // Error handling for user train station input
    // Prevents searching for locations without a valid train station
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "populateTableWithLocations" {
            
            // DISABLED ERROR HANDLING FOR SEARCH BAR
            // TO IMPLEMENT PLACE PICKER
            
//            // Train station not specified
//            if (search.text!.isEmpty) {
//                // Get user input
//                let alert = UIAlertView()
//                alert.title = "Train Station Not Specified"
//                alert.message = "Please enter a valid train station"
//                alert.addButtonWithTitle("Close")
//                alert.show()
//                
//                // Need to reset distance or else next valid result
//                // will send a request with invalid distance in meters
//                distanceRadius = Double(slider.value)
//                
//                return false
//            }
//            // Train station not found in dictionary
//            else if (trainStationInfo[search.text!.lowercaseString] == nil) {
//                // Get user input
//                let alert = UIAlertView()
//                alert.title = "Train Station Not Found"
//                alert.message = "Please enter a valid train station"
//                alert.addButtonWithTitle("Close")
//                alert.show()
//                
//                // Need to reset distance or else next valid result
//                // will send a request with invalid distance in meters
//                distanceRadius = Double(slider.value)
//
//                return false
//            }
        }
        // Transition by default
        return true
    }

    // Pass data from home page to list page
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "populateTableWithLocations") {
            // Get and standardize user input
            trainStation = trainStation.lowercaseString
            distanceRadius = distanceRadius * 1609.34   // convert to meters
            
            // Get the latitude and longitude from user input
            var trainCoordinates: [Double] = [Double]()
            
            let stationFinder: TrainStationFinder = TrainStationFinder(station: trainStation, coordinates: trainCoordinates)
            trainCoordinates = stationFinder.coordinates
            
            let trainLatitude = trainCoordinates[0]
            let trainLongitude = trainCoordinates[1]
            
            // Retrieve data based on user input
            let locationFinder : LocationFinder = LocationFinder(latitude: trainLatitude, longitude: trainLongitude, distance: distanceRadius, locations: locationsList)
            locationsList = locationFinder.locations
            
            // Pass data from home page to navigation controller
            // since list page is embedded into navigation controller
            let firstPage = segue.destinationViewController as! UINavigationController
            let secondPage = firstPage.topViewController as! LocationsViewController;
            secondPage.toPass = locationsList
            secondPage.station = trainStation
            secondPage.stationCoordinates = stationFinder.coordinates
            
        }
    }
    

    

}

