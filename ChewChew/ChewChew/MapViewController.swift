//
//  MapViewController.swift
//  ChewChew
//
//  Created by Clayton To on 10/21/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import UIKit
import GoogleMaps
import SwiftyJSON

/*
    Map page
        Show a route from the user's train station to the selected restaurant
        Allow the user to see their location relative to the route
*/
class MapViewController: UIViewController, GMSMapViewDelegate {

    @IBOutlet var Map: GMSMapView!
    @IBOutlet weak var trackButton: UIButton!
    
    // Station and location coordinates from list page
    var stationCoordinates: [Double]!
    var locationCoordinates: [Double]!
    
    var stationAddress: String!
    var locationAddress: String!
    
    var stationPosition: CLLocationCoordinate2D!
    var locationPosition: CLLocationCoordinate2D!
    
    // Location tracker
    let locationManager = CLLocationManager()
    
    // Whether or not to track user's location
    var trackLocation: Bool = true;
    
    // Google Maps API Key
    let apiKey: String = "AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
    
    // Red color values
    let RED_VALUE: CGFloat = 1
    let GREEN_VALUE: CGFloat = 73/255
    let BLUE_VALUE: CGFloat = 80/255
    
    // Corner radius for button
    let CORNER_RADIUS: CGFloat = 10
    
    override func viewDidLoad() {
        // Set color of back button
        let redColor = UIColor(red: RED_VALUE, green: GREEN_VALUE, blue: BLUE_VALUE, alpha: 1)
        self.navigationController?.navigationBar.tintColor = redColor
        
        // Make positions for the station and restaurant
        stationPosition = CLLocationCoordinate2DMake(stationCoordinates[0], stationCoordinates[1])
        locationPosition = CLLocationCoordinate2DMake(locationCoordinates[0], locationCoordinates[1])
        
        // Get addresses
        stationAddress = reverseGeocodeCoordinates(stationCoordinates[0],long: stationCoordinates[1])
        locationAddress = reverseGeocodeCoordinates(locationCoordinates[0], long: locationCoordinates[1])
        
        // Draw location markers
        placeMarkersOnMap()
        
        // Draw route
        let path = getDirections(stationAddress, destination: locationAddress)
        let route = GMSPolyline(path: path)
        route.map = Map
        
        Map.delegate = self
        
        // Request access to the user's location
        locationManager.delegate = self
        
        // Set up button so that it has rounded corners
        trackButton.layer.cornerRadius = CORNER_RADIUS;
        
        // Add "Start/Stop Walking" button
        Map.addSubview(trackButton)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    // MAP METHODS //
    
    // Draw markers to indicate train station location and restaurant location
    func placeMarkersOnMap (){
        // Create markers
        let locationMarker = GMSMarker(position: locationPosition)
        let stationMarker = GMSMarker(position : stationPosition)
        
        // Set title
        locationMarker.title = locationAddress
        stationMarker.title = stationAddress
        
        // Set color
        let redColor = UIColor(red: RED_VALUE, green: GREEN_VALUE, blue: BLUE_VALUE, alpha: 1)
        locationMarker.icon = GMSMarker.markerImageWithColor(redColor)
        stationMarker.icon = GMSMarker.markerImageWithColor(redColor)
        
        // Center map around station
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(stationCoordinates[0], longitude: stationCoordinates[1], zoom: 14.5)
        Map.camera = camera
        
        // Add markers
        stationMarker.map = Map
        locationMarker.map = Map
    }
    
    // Convert coordinates to addresses
    func reverseGeocodeCoordinates(lat: Double, long: Double) -> String{
        // Create the URL request for Google Geocoding
        let baseURL: String = "https://maps.googleapis.com/maps/api/geocode/json?"
        let url: NSString = "\(baseURL)latlng=\(lat),\(long)&key=\(apiKey)"
        
        // Format URL
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL: NSURL = NSURL(string:urlString as String)!
        
        // Retrieve addresses
        let jsonData = NSData(contentsOfURL:searchURL)
        let json = JSON(data: jsonData!)
        let address: String = json["results"][0]["formatted_address"].string!
        
        // Return address
        return address
    }
    
    // Get directions between two locations
    func getDirections(origin: String, destination: String) -> GMSMutablePath{
        // Create URL request for Google Directions
        let baseURL: String = "https://maps.googleapis.com/maps/api/directions/json?"
        let url: NSString = "\(baseURL)origin=\(origin)&destination=\(destination)&mode=walking&key=\(apiKey)"
        
        // Format URL
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL: NSURL = NSURL(string:urlString as String)!
        
        // Retrieve directions
        let jsonData = NSData(contentsOfURL:searchURL)
        let json = JSON(data: jsonData!)
        
        // Represent path as list of coordinates
        var coordinatesArray = [[Double]]()
        
        // Starting point is the user's train station
        coordinatesArray.append(stationCoordinates)
        
        // Fill list with retrieved coordinates
        for point in json["routes"][0]["legs"][0]["steps"].arrayValue {
            var pointCoordinates = [Double]()
            
            // Latitude and longitude
            pointCoordinates.append(point["end_location"]["lat"].double!)
            pointCoordinates.append(point["end_location"]["lng"].double!)
            
            coordinatesArray.append(pointCoordinates)
        }
        
        // Define path based on the list of coordinates
        let path = GMSMutablePath()
        
        for coordinate in coordinatesArray{
            path.addCoordinate(CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
        }
        
        return path
    }

    // LOCATION TRACKING METHODS //
    
    // Start tracking user's location
    func startWalking(){
        Map.myLocationEnabled = true            // draw blue dot
        Map.settings.myLocationButton = true    // draw compass button
        
        trackButton.setTitle("Stop Walking", forState: .Normal)
    }

    // Stop tracking user's location
    func stopWalking(){
        Map.myLocationEnabled = false
        Map.settings.myLocationButton = false
        
        trackButton.setTitle("Start Walking", forState: .Normal)
    }

    // Toggle between tracking and not tracking user's location
    @IBAction func trackPressed(sender: UIButton) {
        // Ask for permission the first time
        locationManager.requestWhenInUseAuthorization()
        
        if (trackLocation) {
            startWalking()
            trackLocation = false;
        } else {
            stopWalking()
            trackLocation = true;
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}

// MARK: - CLLocationManagerDelegate

extension MapViewController: CLLocationManagerDelegate {
    // Called when user grants or revokes location permissions
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        
        // Verify that user granted permission
        if status == CLAuthorizationStatus.AuthorizedWhenInUse {
            // Get updates on user's location
            locationManager.startUpdatingLocation()
        }
    }
    
    // Called when location manager receives new location data
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.first {
            locationManager.stopUpdatingLocation()
        }
        
    }
}

