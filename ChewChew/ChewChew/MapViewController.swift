//
//  MapViewController.swift
//  ChewChew
//
//  Created by Clayton To on 10/21/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import UIKit
import GoogleMaps

class MapViewController: UIViewController {

    @IBOutlet var Map: GMSMapView!
    
    // station and location data from results page
    var stationName: String!
    var stationCoordinates: [Double]!
    var locationCoordinates: [Double]!
    var locationName: String!
    
    override func  viewDidLoad() {
        // making the positions for the station and the marker
        let locationPosition = CLLocationCoordinate2DMake(locationCoordinates[0], locationCoordinates[1])
        let stationPosition = CLLocationCoordinate2DMake(stationCoordinates[0], stationCoordinates[1])
        //making the markers for the station and the location
        let locationMarker = GMSMarker(position: locationPosition)
        let stationMarker = GMSMarker(position : stationPosition)
        locationMarker.title = locationName
        stationMarker.title = stationName
        // cneter the map around the station
        let camera: GMSCameraPosition = GMSCameraPosition.cameraWithLatitude(stationCoordinates[0], longitude: stationCoordinates[1], zoom: 15.0)
        Map.camera = camera
        //placing the markers on the map
        stationMarker.map = Map
        locationMarker.map = Map
        

    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
