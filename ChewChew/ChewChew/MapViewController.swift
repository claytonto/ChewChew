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

class MapViewController: UIViewController {

    @IBOutlet var Map: GMSMapView!
    @IBOutlet weak var trackButton: UIButton!
    let locationManager = CLLocationManager()
    
    
    // station and location data from results page
    var stationName: String!
    var locationName: String!
    var stationCoordinates: [Double]!
    var locationCoordinates: [Double]!
    
    
    var stationAddress: String!
    var locationAddress: String!
    
    var stationPosition: CLLocationCoordinate2D!
    var locationPosition: CLLocationCoordinate2D!
    
    

    
    override func  viewDidLoad() {
        // making the positions for the station and the marker
        stationPosition = CLLocationCoordinate2DMake(stationCoordinates[0], stationCoordinates[1])
        locationPosition = CLLocationCoordinate2DMake(locationCoordinates[0], locationCoordinates[1])
        // getting the addresses
        stationAddress = reverseGeocodeCoordinates(stationCoordinates[0],long: stationCoordinates[1])
        locationAddress = reverseGeocodeCoordinates(locationCoordinates[0], long: locationCoordinates[1])
        //place the location markers on the map
        placeMarkersOnMap()
        // get the directions and place the route on the map
        getDirections(stationAddress,destination: locationAddress)
        let path = getDirections(stationAddress, destination: locationAddress)
        let route = GMSPolyline(path: path)
        route.map = Map
        
        Map.addSubview(trackButton)
        locationManager.requestWhenInUseAuthorization()

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func placeMarkersOnMap (){
        //creating markers to be placed
        let locationMarker = GMSMarker(position: locationPosition)
        let stationMarker = GMSMarker(position : stationPosition)
        locationMarker.title = locationAddress
        stationMarker.title = stationAddress
        // center the map around the station
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(stationCoordinates[0], longitude: stationCoordinates[1], zoom: 13.5)
        Map.camera = camera
        //placing the markers on the map
        stationMarker.map = Map
        locationMarker.map = Map
        
    }
    
    func reverseGeocodeCoordinates(lat :Double, long :Double) -> String{
        //creating the url for the json request
        let url: NSString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(long)&key=AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL: NSURL = NSURL(string:urlString as String)!
        // getting and parsing the json
        let jsonData = NSData(contentsOfURL:searchURL)
        let json = JSON(data: jsonData!)
        let address: String = json["results"][0]["formatted_address"].string!
        //return the address
        return address
    }
    
    func getDirections(origin :String, destination :String) -> GMSMutablePath{
        //creating the request url
        let url: NSString = "https://maps.googleapis.com/maps/api/directions/json?origin=\(origin)&destination=\(destination)&mode=walking&key=AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL: NSURL = NSURL(string:urlString as String)!
        // getting and parsing the json
        let jsonData = NSData(contentsOfURL:searchURL)
        let json = JSON(data: jsonData!)
        //creating the array of coordinates
        var coordinatesArray = [[Double]]()
        coordinatesArray.append(stationCoordinates)
        //filling the array with coordinates
        for point in json["routes"][0]["legs"][0]["steps"].arrayValue {
            var pointCoordinates = [Double]()
            pointCoordinates.append(point["end_location"]["lat"].double!)
            pointCoordinates.append(point["end_location"]["lng"].double!)
            coordinatesArray.append(pointCoordinates)
        }
        //defining a path based on the coordinates in the array
        let path = GMSMutablePath()
        for coordinate in coordinatesArray{
            path.addCoordinate(CLLocationCoordinate2D(latitude: coordinate[0], longitude: coordinate[1]))
        }
        // returning the path
        return path
    }
    
    
    
    // FUNCTIONS FOR TRACKING THESE METHODS ARE STILL IN DEVELOPMENT
    //COMMENT OUT FUNCTIONS AS NEEDED TO TEST
    func startWalking(){
        Map.myLocationEnabled = true
        trackButton.setTitle("Stop Walking", forState: .Normal)
        track()
        
    }
    
    func track(){
        var lat = Map.myLocation.coordinate.latitude
        var lng = Map.myLocation.coordinate.longitude
        var cam = GMSCameraPosition()
        
        while Map.myLocationEnabled == true{
            lat = Map.myLocation.coordinate.latitude
            lng = Map.myLocation.coordinate.longitude
            cam = GMSCameraPosition.cameraWithLatitude(lat, longitude: lng, zoom: 15.0)
            Map.camera = cam
        }
    }
    
    func stopWalking(){
        Map.myLocationEnabled = false
        trackButton.setTitle("Start Walking", forState: .Normal)
    }
    
    @IBAction func trackPressed(sender: UIButton) {
        if sender == trackButton{
            if Map.myLocationEnabled == false{
                startWalking()
            } else {
                stopWalking()
            }
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
