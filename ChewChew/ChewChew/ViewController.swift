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
import GoogleMaps

/*
    Home page
        Allow the user to enter train station and distance willing to travel
*/
class ViewController: UIViewController, NSURLConnectionDataDelegate {
    
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var searchButton: UIButton!
    
    // Background color
    let gradientLayer = CAGradientLayer()
    
    // User input
    var stationID: String = ""
    var distanceRadius: Double = 1.5
    
    // Dictionary of result names and their Place ID's
    var locations = [String: String]()
    
    // Results based on user input
    var locationsList: [Location] = [Location]()
    
    // Conversion values
    let METERS_PER_MILE: Double = 1609.34
    let ONE_DIGIT: Double = 10.0
    
    
    
    
    
    // Update the slider label to match value
    @IBAction func sliderValueChanged(sender: UISlider) {
        distanceRadius = Double(sender.value)
        
        // only show 1 digit after decimal
        distanceRadius = round(ONE_DIGIT*distanceRadius)/ONE_DIGIT
        
        label.text = "\(distanceRadius) miles"
    }
    
    // Search button actions already handled by segue
    @IBAction func searchPressed(sender: UIButton) {}
    
    
    
    
    
    // OVERRIDE FUNCTIONS //
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Set up button so that it has rounded corners
        searchButton.layer.cornerRadius = 10;
        
        // Set up slider so that the right side is orange
        slider.maximumTrackTintColor = UIColor.orangeColor()
        
        // Set up background gradient
        gradientLayer.frame = self.view.bounds
        
        let color1 = UIColor(red: 232/255, green: 83/255, blue: 69/255, alpha: 1.0).CGColor as CGColorRef
        let color2 = UIColor(red: 206/255, green: 70/255, blue: 53/255, alpha: 1.0).CGColor as CGColorRef
        gradientLayer.colors = [color1, color2]
        
        gradientLayer.locations = [0.0, 1.0]
        
        self.view.layer.insertSublayer(gradientLayer, atIndex: 0)
        
        // Set up autocomplete text box
        configureTextField()
        handleTextFieldInterfaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    // AUTOCOMPLETE METHODS //
    
    private var connection:NSURLConnection?
    private var responseData:NSMutableData?
    
    private let googleMapsKey = "AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    // Highlight matching substrings between user input and autocomplete
    private func configureTextField(){
        // Enable formatting
        autocompleteTextfield.enableAttributedText = true
        
        var attributes = [String:AnyObject]()
        
        // Make matching strings red
        let fontColor = UIColor(red: 1, green: 73/255, blue: 80/255, alpha: 1)
        attributes[NSForegroundColorAttributeName] = fontColor
        
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    // Handle autocomplete requests and selections
    private func handleTextFieldInterfaces(){
        
        // Fetch autocomplete predictions as user types
        autocompleteTextfield.onTextChange = {[weak self] text in
            // Only fetch predictions when there is input
            if !text.isEmpty{
                if self!.connection != nil{
                    self!.connection!.cancel()
                    self!.connection = nil
                }
                // Create the URL request to Google Places Autocomplete
                let urlString = "\(self!.baseURLString)?key=\(self!.googleMapsKey)&input=\(text)&types=geocode"
                let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)!)
                
                // Retrieve place predictions
                if url != nil{
                    let urlRequest = NSURLRequest(URL: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                }
            }
        }
        
        // Select autocomplete prediction
        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
            // Save train station place ID
            self!.stationID = self!.locations[text]!
            
            // Update text to show selected station
            self!.autocompleteTextfield.text = text
            
            // Dismiss keyboard after selecting station
            self!.view.endEditing(true)
        }
    }

    //MARK: NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    // Parse retrieved data
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if let data = responseData {
            
            do {
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                if let status = result["status"] as? String{
                    if status == "OK"{
                        var displayPredictions = [String]()

                        // Retrieve autocomplete predictions
                        if let predictions = result["predictions"] as? NSArray{
                            for dict in predictions as! [NSDictionary]{
                                var nameOfResult = dict["description"] as! String
                                
                                // Restrict results to train stations
                                if nameOfResult.rangeOfString("Station") != nil {
                                    // Save location
                                    displayPredictions.append(nameOfResult)
                                    
                                    // Save location's respective Place ID
                                    var placeID = dict["place_id"] as! String
                                    locations[nameOfResult] = placeID
                                }
                            }
                            // Save the retrieved predictions
                            self.autocompleteTextfield.autoCompleteStrings = displayPredictions
                            return
                        }
                    }
                }
                self.autocompleteTextfield.autoCompleteStrings = nil
            }
            catch let error as NSError{
                print("Error: \(error.localizedDescription)")
            }
        }
    }
    
    func connection(connection: NSURLConnection, didFailWithError error: NSError) {
        print("Error: \(error.localizedDescription)")
    }

    
    
    
    
    // SEGUE METHODS //
    
    // Error handling for user train station input
    // Prevents searching for locations without a valid train station
    override func shouldPerformSegueWithIdentifier(identifier: String, sender: AnyObject!) -> Bool {
        if identifier == "populateTableWithLocations" {
            // Train station not specified
            if (autocompleteTextfield.text!.isEmpty) {
                let alert = UIAlertView()
                alert.title = "Train Station Not Specified"
                alert.message = "Please enter a valid train station"
                alert.addButtonWithTitle("Close")
                alert.show()
                
                // Need to reset distance or else next valid result
                // will send a request with invalid distance in meters
                distanceRadius = Double(slider.value)
                
                return false
            }
        }
        // Transition by default
        return true
    }

    // Pass data from home page to list page
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if (segue.identifier == "populateTableWithLocations") {
    
            // Convert to meters
            distanceRadius = distanceRadius * METERS_PER_MILE
            
            // Get coordinates of train station
            var trainCoordinates: [Double] = [Double]()

            let coordinateFinder : CoordinateFinder = CoordinateFinder(placeID: stationID, coordinates: trainCoordinates)
            trainCoordinates = coordinateFinder.coordinates
                        
            // Retrieve restaurants based on user input
            let locationFinder : LocationFinder = LocationFinder(latitude: trainCoordinates[0], longitude: trainCoordinates[1], distance: distanceRadius, locations: locationsList)
            
            locationsList = locationFinder.locations
                        
            // Pass data from home page to navigation controller
            // since list page is embedded into navigation controller
            let firstPage = segue.destinationViewController as! UINavigationController
            let secondPage = firstPage.topViewController as! LocationsViewController;
            
            secondPage.toPass = locationsList
            secondPage.stationCoordinates = trainCoordinates
        }
    }
    

    

}



