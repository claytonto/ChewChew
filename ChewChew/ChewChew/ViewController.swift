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

class ViewController: UIViewController, NSURLConnectionDataDelegate {
    
    @IBOutlet weak var autocompleteTextfield: AutoCompleteTextField!
    @IBOutlet weak var slider: UISlider!
    @IBOutlet weak var label: UILabel!
    
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
        
        // Autocomplete search box
        configureTextField()
        handleTextFieldInterfaces()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    
    // AUTOCOMPLETE METHODS //
    
    private var connection:NSURLConnection?
    private var responseData:NSMutableData?
    
    private let googleMapsKey = "AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
    private let baseURLString = "https://maps.googleapis.com/maps/api/place/autocomplete/json"
    
    private func configureTextField(){
        autocompleteTextfield.autoCompleteTextColor = UIColor(red: 128.0/255.0, green: 128.0/255.0, blue: 128.0/255.0, alpha: 1.0)
        autocompleteTextfield.autoCompleteTextFont = UIFont(name: "HelveticaNeue-Light", size: 12.0)
        autocompleteTextfield.autoCompleteCellHeight = 35.0
        autocompleteTextfield.maximumAutoCompleteCount = 20
        autocompleteTextfield.hidesWhenSelected = true
        autocompleteTextfield.hidesWhenEmpty = true
        autocompleteTextfield.enableAttributedText = true
        var attributes = [String:AnyObject]()
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor()
        attributes[NSFontAttributeName] = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        autocompleteTextfield.autoCompleteAttributes = attributes
    }
    
    private func handleTextFieldInterfaces(){
        autocompleteTextfield.onTextChange = {[weak self] text in
            if !text.isEmpty{
                if self!.connection != nil{
                    self!.connection!.cancel()
                    self!.connection = nil
                }
                let urlString = "\(self!.baseURLString)?key=\(self!.googleMapsKey)&input=\(text)&types=geocode"
                let url = NSURL(string: (urlString as NSString).stringByAddingPercentEscapesUsingEncoding(NSASCIIStringEncoding)!)
                if url != nil{
                    let urlRequest = NSURLRequest(URL: url!)
                    self!.connection = NSURLConnection(request: urlRequest, delegate: self)
                }
            }
        }
        
        // TO DO: ALLOW USER TO SELECT AUTOCOMPLETE SUGGESTION
        
//        autocompleteTextfield.onSelect = {[weak self] text, indexpath in
//            AutocompleteLocation.geocodeAddressString(text, completion: { (placemark, error) -> Void in
//                if let coordinate = placemark?.location?.coordinate{
//                    self!.addAnnotation(coordinate, address: text)
//                    self!.mapView.setCenterCoordinate(coordinate, zoomLevel: 12, animated: true)
//                }
//            })
//        }
    }

    //MARK: NSURLConnectionDelegate
    func connection(connection: NSURLConnection, didReceiveResponse response: NSURLResponse) {
        responseData = NSMutableData()
    }
    
    func connection(connection: NSURLConnection, didReceiveData data: NSData) {
        responseData?.appendData(data)
    }
    
    func connectionDidFinishLoading(connection: NSURLConnection) {
        if let data = responseData{
            
            do{
                let result = try NSJSONSerialization.JSONObjectWithData(data, options: .AllowFragments)
                
                if let status = result["status"] as? String{
                    if status == "OK"{
                        if let predictions = result["predictions"] as? NSArray{
                            var locations = [String]()
                            for dict in predictions as! [NSDictionary]{
                                var nameOfResult = dict["description"] as! String
                                
                                // restrict results to train stations
                                if nameOfResult.rangeOfString("Station") != nil {
                                    locations.append(dict["description"] as! String)
                                }
                            }
                            self.autocompleteTextfield.autoCompleteStrings = locations
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

