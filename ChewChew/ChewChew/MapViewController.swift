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
    
    // station and location data from results page
    var stationName: String!
    var stationCoordinates: [Double]!
    var locationCoordinates: [Double]!
    var locationName: String!
    
    var stationAddress: String!
    var locationAddress: String!
    
    var stationPosition: CLLocationCoordinate2D!
    var locationPosition: CLLocationCoordinate2D!
    
    override func  viewDidLoad() {
        // making the positions for the station and the marker
        stationPosition = CLLocationCoordinate2DMake(stationCoordinates[0], stationCoordinates[1])
        locationPosition = CLLocationCoordinate2DMake(locationCoordinates[0], locationCoordinates[1])
        placeMarkersOnMap()
        reverseGeocodeCoordinates(stationCoordinates[0],long: stationCoordinates[1])

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func placeMarkersOnMap (){
        //creating markers to be placed
        let locationMarker = GMSMarker(position: locationPosition)
        let stationMarker = GMSMarker(position : stationPosition)
        locationMarker.title = locationName
        stationMarker.title = stationName
        // center the map around the station
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(stationCoordinates[0], longitude: stationCoordinates[1], zoom: 12.0)
        Map.camera = camera
        //placing the markers on the map
        stationMarker.map = Map
        locationMarker.map = Map
    }
    
    func reverseGeocodeCoordinates(lat :Double, long :Double){
        let url: NSString = "https://maps.googleapis.com/maps/api/geocode/json?latlng=\(lat),\(long)&key=AIzaSyByM6vaj-YYY1dt3qd99JS7NrA6KmkRY5Q"
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchURL: NSURL = NSURL(string:urlString as String)!
        
        let jsonData = NSData(contentsOfURL: searchURL)
        let json = JSON(data: jsonData!)
        print(json)

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
