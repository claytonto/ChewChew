//
//  TrainStationFinder.swift
//  ChewChew
//
//  Created by Maureen Naval on 10/9/15.
//  Copyright © 2015 ChewChew. All rights reserved.
//

import Foundation
import SwiftyJSON

/*
    Find a Place ID's corresponding latitude and longitude coordinates
    Input: PlaceID and an array to store the coordinates
    Can directly access the updated coordinates array
*/
class CoordinateFinder {
    // Latitude and longitude coordinates
    var coordinates: [Double]
    
    init(placeID: String, coordinates: [Double]) {
        // Override given empty coordinate array
        self.coordinates = coordinates
    
        // Create the URL request for Place Details
        let baseURL: String = "https://maps.googleapis.com/maps/api/place/details/json?"
        let apiKey: String = "AIzaSyDEVGwrwo767rgEQOfe_FcHR-_QYr9pOc8"
        let url: NSString = "\(baseURL)placeid=\(placeID)&key=\(apiKey)"
        
        // Format URL for JSON request
        let urlString: NSString = url.stringByAddingPercentEscapesUsingEncoding(NSUTF8StringEncoding)!
        let searchUrl: NSURL = NSURL(string:urlString as String)!
        
        // Retrieve Place Details
        let jsonData = NSData(contentsOfURL: searchUrl)
        let json = JSON(data: jsonData!)
                
        // Parse JSON for latitude and longitude
        let latitude:Double = json["result"]["geometry"]["location"]["lat"].double!
        let longitude:Double = json["result"]["geometry"]["location"]["lng"].double!

        // Save coordinates
        self.coordinates.append(latitude)
        self.coordinates.append(longitude)
    }
}